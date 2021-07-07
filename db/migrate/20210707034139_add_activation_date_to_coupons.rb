class AddActivationDateToCoupons < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons, :activation_date, :date
    add_column :brands, :earliest_activation_date, :date
    add_column :brands, :latest_activation_date, :date
  end
end
