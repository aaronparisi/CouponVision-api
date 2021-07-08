class RenameMaxNumCouponsInGrocers < ActiveRecord::Migration[6.1]
  def change
    rename_column :grocers, :max_num_coupons, :max_num_coupons_per_store
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
