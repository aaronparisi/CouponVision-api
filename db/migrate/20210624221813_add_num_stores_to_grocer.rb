class AddNumStoresToGrocer < ActiveRecord::Migration[6.1]
  def change
    add_column :grocers, :num_stores, :integer
  end
end
