# == Schema Information
#
# Table name: grocers
#
#  id              :bigint           not null, primary key
#  max_num_coupons :integer
#  name            :string
#  num_brands      :integer
#  num_stores      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Grocer < ApplicationRecord
  has_many :stores
  has_many :coupons, through: :stores, source: :coupons

  has_many :grocer_brands
  has_many :brands, through: :grocer_brands, source: :brand

  def self.coupon_counts_by_brand
    # self.coupons.joins(product: [:brand]).group(:brand_id).count(:id)
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

  def coupons_by_brand
    self
      .coupons
      .joins(product: [:brand])
      .order(:expiration_date)
      .pluck(:id, :brand_id, :expiration_date)
      .map { |coupon| { id: coupon[0], brand_id: coupon[1], expiration_date: coupon[2] }}
  end
end

=begin
Grocer.left_outer_joins(stores: [coupons: [product: [:brand]]]).group(:brand_id, :id).count(:coupon_id)
Store.joins(:coupon)

select 
  G.id as id,
  G.name as name, 
  B.id as brand_id, 
  B.name as brand_name,
  count(case S.grocer_id when C.id then 1 else null end) as num_coupons
from "grocers" as G, "brands" as B
inner join "products" P
  on P.brand_id = B.id
inner join "coupons" as C
  on C.product_id = P.id
inner join "stores" as S
  on S.id = C.store_id
group by G.id, B.id
order by G.name, B.name;
=end