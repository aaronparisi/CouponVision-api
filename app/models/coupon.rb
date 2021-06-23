# == Schema Information
#
# Table name: coupons
#
#  id              :bigint           not null, primary key
#  cash_value      :decimal(, )
#  expiration_date :date
#  savings         :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint           not null
#
# Indexes
#
#  index_coupons_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Coupon < ApplicationRecord
  belongs_to :product

  has_many :coupon_stores
  has_many :stores, through: :coupon_stores, source: :store_id
end
