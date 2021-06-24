class AddNumProductsToBrands < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :num_products, :integer
  end
end
