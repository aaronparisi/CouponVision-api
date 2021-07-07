class RemoveExpirationDatesFromBrands < ActiveRecord::Migration[6.1]
  def change
    remove_column :brands, :earliest_expiration_date
    remove_column :brands, :latest_expiration_date
    add_column :brands, :max_activation_days, :integer
  end
end
