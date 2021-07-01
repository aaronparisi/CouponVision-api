# == Schema Information
#
# Table name: brands
#
#  id                       :bigint           not null, primary key
#  earliest_expiration_date :date
#  latest_expiration_date   :date
#  max_coupon_value         :decimal(, )
#  min_coupon_value         :decimal(, )
#  name                     :string
#  num_products             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
end
