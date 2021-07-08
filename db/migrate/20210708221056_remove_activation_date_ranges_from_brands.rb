class RemoveActivationDateRangesFromBrands < ActiveRecord::Migration[6.1]
  def change
    remove_column :brands, :earliest_activation_date
    remove_column :brands, :latest_activation_date
  end
end
