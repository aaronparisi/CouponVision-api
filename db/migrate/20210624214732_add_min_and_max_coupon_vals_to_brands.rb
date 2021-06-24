class AddMinAndMaxCouponValsToBrands < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :min_coupon_value, :decimal
    add_column :brands, :max_coupon_value, :decimal
  end
end
