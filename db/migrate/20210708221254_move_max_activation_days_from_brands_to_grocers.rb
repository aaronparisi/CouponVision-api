class MoveMaxActivationDaysFromBrandsToGrocers < ActiveRecord::Migration[6.1]
  def change
    remove_column :brands, :max_activation_days
    add_column :grocers, :max_activation_days, :date
  end
end
