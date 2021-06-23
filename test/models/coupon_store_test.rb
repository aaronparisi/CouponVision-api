# == Schema Information
#
# Table name: coupon_stores
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  coupon_id  :bigint           not null
#  store_id   :bigint           not null
#
# Indexes
#
#  index_coupon_stores_on_coupon_id  (coupon_id)
#  index_coupon_stores_on_store_id   (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (coupon_id => coupons.id)
#  fk_rails_...  (store_id => stores.id)
#
require "test_helper"

class CouponStoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
