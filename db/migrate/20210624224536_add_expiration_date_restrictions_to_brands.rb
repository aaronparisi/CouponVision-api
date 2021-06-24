class AddExpirationDateRestrictionsToBrands < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :earliest_expiration_date, :date
    add_column :brands, :latest_expiration_date, :date
  end
end
