# == Schema Information
#
# Table name: coupons
#
#  id              :bigint           not null, primary key
#  activation_date :date
#  cash_value      :decimal(, )
#  expiration_date :date
#  savings         :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint           not null
#  store_id        :bigint
#
# Indexes
#
#  index_coupons_on_product_id  (product_id)
#  index_coupons_on_store_id    (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (store_id => stores.id)
#
require "test_helper"

class CouponTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
