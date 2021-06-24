class DropTableCouponStores < ActiveRecord::Migration[6.1]
  def change
    drop_table :coupon_stores
  end
end
