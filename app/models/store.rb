# == Schema Information
#
# Table name: stores
#
#  id             :bigint           not null, primary key
#  city           :string
#  num_coupons    :integer
#  state          :string
#  street_address :string
#  zip            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  grocer_id      :bigint
#
# Indexes
#
#  index_stores_on_grocer_id  (grocer_id)
#
# Foreign Keys
#
#  fk_rails_...  (grocer_id => grocers.id)
#
class Store < ApplicationRecord
  belongs_to :grocer

  has_many :coupons
  has_many :products, through: :coupons, source: :product

  def total_store_savings
    savings = self.coupons.reduce(0) { |total, coupon| total + coupon.savings }

    return savings.round(2).to_f
  end
  
  def full_of_coupons?
    return self.coupons.count >= self.num_coupons
  end
end
