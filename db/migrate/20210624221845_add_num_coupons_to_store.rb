class AddNumCouponsToStore < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :num_coupons, :integer
  end
end
