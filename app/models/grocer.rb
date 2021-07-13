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
    ## anote
    ## originally I executed this query because I thought I needed
    ## to send back grocer objects in which EVERY brand was represented
    ## regardless of whether or not any particular grocer
    ## actually had coupons for that brand
    ## It seems, however, that the stack generator in the react component
    ## does not need to explicitly see a '0' count for a key;
    ## the absence of the key leads to a bar of width 0

    # query = <<-SQL
    #   select 
    #     G.id as id,
    #     G.name as grocer_name, 
    #     B.id as brand_id, 
    #     B.name as brand_name,
    #     count(case S.grocer_id when G.id then 1 else null end) as coupon_count
    #   from "grocers" as G, "brands" as B
    #   inner join "products" P
    #     on P.brand_id = B.id
    #   inner join "coupons" as C
    #     on C.product_id = P.id
    #   inner join "stores" as S
    #     on S.id = C.store_id
    #   group by G.id, B.id
    #   order by G.name, B.name;
    # SQL

    # data = ActiveRecord::Base.connection.execute(query)
    data = self
      .joins(coupons: [product: [:brand]])
      .group("grocers.id", "brands.id")
      .pluck(
        "grocers.name as grocer_name", 
        "brands.id as brand_id",
        "count(coupons.id) as coupon_count"
      )

    ## at this point, data consists of many rows for a single grocer
    ## we want to smush each brand-coupon-count into a single entry for each grocer
    ## anote I thought it was easier to put everything in an object
    ##       with grocer_names as keys
    ##       as opposed to going right to the final array,
    ##       where I'd have to be continuously looking for the index
    ##       of some object in the array whose grocer_name key
    ##       had a particular value
    ## ???? is there a way to do this in the query itself?
    flattened = {}
    ret = []

    data.each do |grocer|
      if flattened[grocer[0]]
        flattened[grocer[0]][grocer[1]] = grocer[2]
      else
        flattened[grocer[0]] = { grocer[1] => grocer[2] }
      end
    end

    flattened.each do |grocer_name, counts|
      ret.push({ grocer_name: grocer_name }.merge(counts))
    end
    
    return ret
  end

  def self.active_over_time
    data = self
      .joins(stores: [:coupons])
      .pluck(
        "grocers.name as grocer_name",
        "coupons.activation_date as activation_date",
        "coupons.expiration_date as expiration_date"
      )

    ## at this point, data has a single row for each coupon (many with same grocer id)
    ## we want an array where each grocer is represented once,
    ## and their coupons are encapsulated in an array
    flattened = {}
    ret = []

    data.each do |row|
      if flattened[row[0]]
        flattened[row[0]].push(
          { 
            activation_date: row[1], 
            expiration_date: row[2] 
          }
        )
      else
        flattened[row[0]] = [
          {
            activation_date: row[1], 
            expiration_date: row[2] 
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