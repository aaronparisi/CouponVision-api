class AddNumBrandsToGrocers < ActiveRecord::Migration[6.1]
  def change
    add_column :grocers, :num_brands, :integer
  end
end
