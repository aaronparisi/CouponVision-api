# == Schema Information
#
# Table name: grocers
#
#  id                        :bigint           not null, primary key
#  earliest_activation_date  :date
#  latest_activation_date    :date
#  max_activation_days       :integer
#  max_num_coupons_per_store :integer
#  name                      :string
#  num_brands                :integer
#  num_stores                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Grocer < ApplicationRecord
  has_many :stores
  has_many :coupons, through: :stores, source: :coupons

  has_many :grocer_brands
  has_many :brands, through: :grocer_brands, source: :brand

  ## for counts per brand stacked bar chart
  def self.coupon_counts_by_brand
    ## the goal here is to return a set of data consisting of
    ## arrays of objects
    ## each object represents a grocer
    ## and will have keys for grocer name,
    ## as well as a key-value pair representing each brand id
    ## and corresponding coupon count for said grocer
    ## e.g.
    ## [{ 1: 5, 2: 0, grocer_name: "Albertson's" }, { 1: 1, 2: 2, grocer_name: "QFC" }, ...]
    ## we need the data formatted in this way because of how we construct
    ## "layers" in D3 - where a layer corresponds to all bars
    ## for any particular brand.
    ## => layers will look through the grocers and grab all the values
    ##    for each brand_id
    ## e.g.
    ## there will be a layer for brand # 1 that has a bar "5 wide"
    ## and a bar "1 wide", and a layer for brand # 2 with a bar "0 wide"
    ## and a bar "2 wide"
    query = <<-SQL
      select 
        G.id as id,
        G.name as grocer_name, 
        B.id as brand_id, 
        B.name as brand_name,
        count(case S.grocer_id when G.id then 1 else null end) as coupon_count
      from "grocers" as G, "brands" as B
      inner join "products" P
        on P.brand_id = B.id
      inner join "coupons" as C
        on C.product_id = P.id
      inner join "stores" as S
        on S.id = C.store_id
      group by G.id, B.id
      order by G.name, B.name;
    SQL

    data = ActiveRecord::Base.connection.execute(query)

    ## at this point, data consists of many rows for a single grocer
    ## we want to smush each brand-coupon-count into a single entry for each grocer
    flattened = {}
    ret = []

    data.each do |grocer|
      if flattened[grocer["grocer_name"]]
        flattened[grocer["grocer_name"]][grocer["brand_id"]] = grocer["coupon_count"]
      else
        flattened[grocer["grocer_name"]] = { grocer["brand_id"] => grocer["coupon_count"] }
      end
    end

    flattened.each do |grocer_name, counts|
      ret.push({ grocer_name: grocer_name }.merge(counts))
    end

    return ret
  end

  def self.active_over_time
    query = <<-SQL
    select 
      G.name as grocer_name,
      C.id as coupon_id, 
      C.activation_date as activation_date, 
      C.expiration_date as expiration_date
    from grocers G
    join stores S
    on G.id = S.grocer_id
    join coupons C
    on S.id = C.store_id;
    SQL
    ## atodo maybe just do this with active record query methods...
    ## the issue is that Grocer.joins(:coupons).pluck(:name, ...)
    ## doesn't return an object with keys
    ## we could try doing a reduce on the results of the query,
    ## but it's tedius to find out if the accumulator has
    ## an object with the grocer name already is all
    data = ActiveRecord::Base.connection.execute(query)

    ## at this point, data has a single row for each coupon (many with same grocer id)
    ## we want an array where each grocer is represented once,
    ## and their coupons are encapsulated in an array
    flattened = {}
    ret = []

    data.each do |row|
      if flattened[row["grocer_name"]]
        flattened[row["grocer_name"]].push(
          { 
            activation_date: row["activation_date"], 
            expiration_date: row["expiration_date"] 
          }
        )
      else
        flattened[row["grocer_name"]] = [
          {
            activation_date: row["activation_date"], 
            expiration_date: row["expiration_date"] 
          }
        ]
      end
    end

    flattened.each do |grocer_name, coupons|
      ret.push({ name: grocer_name, coupons: coupons })
    end

    return ret
  end
end