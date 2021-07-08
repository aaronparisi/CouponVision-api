class ChangeGrocersMaxActivationDaysFromDateToInteger < ActiveRecord::Migration[6.1]
  def change
    remove_column :grocers, :max_activation_days
    add_column :grocers, :max_activation_days, :integer
  end
end
