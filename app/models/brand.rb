# == Schema Information
#
# Table name: brands
#
#  id               :bigint           not null, primary key
#  max_coupon_value :decimal(, )
#  min_coupon_value :decimal(, )
#  name             :string
#  num_products     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Brand < ApplicationRecord
  has_many :products
  has_many :coupons, through: :products, source: :coupons

  has_many :grocer_brands
  has_many :grocers, through: :grocer_brands, source: :grocer

  def full_of_products?
    return self.products.count >= self.num_products
  end

  def self.all_full?
    return self.all.all? { |brand| brand.full_of_products? }
  end
  # limiting seeding products by each brand's num_products might have made these
  # obsolete

  def self.savings_by_brand
    query = <<-SQL
      select
        B.name as brand_name,
        C.activation_date as activation_date,
        C.expiration_date as expiration_date,
        C.savings as savings,
        S.state
      from brands B
      join products P
      on B.id = P.brand_id
      join coupons C
      on P.id = C.product_id
      join stores S
      on S.id = C.store_id
    SQL

    data = ActiveRecord::Base.connection.execute(query)

    flattened = {}
    children = []

    data.each do |row|
      if flattened[row["brand_name"]]
        if flattened[row["brand_name"]][row["state"]]
          flattened[row["brand_name"]][row["state"]].push(
            { 
              activation_date: row["activation_date"], 
              expiration_date: row["expiration_date"],
              savings: row["savings"]
            }
          )
        else
          flattened[row["brand_name"]][row["state"]] = [
            { 
              activation_date: row["activation_date"], 
              expiration_date: row["expiration_date"],
              savings: row["savings"]
            }
          ]
        end
      else
        flattened[row["brand_name"]] = {}
        flattened[row["brand_name"]][row["state"]] = [
          {
            activation_date: row["activation_date"], 
            expiration_date: row["expiration_date"],
            savings: row["savings"]
          }
        ]
      end
    end

    flattened.each do |brand_name, coupons|
      children.push({ 
        name: brand_name, 
        children: coupons.map { |state_name, coupons| { name: state_name, children: coupons }}
      })
    end
    
    return {
      name: "brands",
      children: children
    }
  end
end