class AddMaxNumCouponsToGrocers < ActiveRecord::Migration[6.1]
  def change
    add_column :grocers, :max_num_coupons, :integer
  end
end
