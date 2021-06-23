# == Schema Information
#
# Table name: stores
#
#  id             :bigint           not null, primary key
#  city           :string
#  state          :string
#  street_address :string
#  zip            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :bigint           not null
#
# Indexes
#
#  index_stores_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Store < ApplicationRecord
  belongs_to :company

  has_many :coupon_stores
  has_many :coupons, through: :coupon_stores, source: :coupon_id
end
