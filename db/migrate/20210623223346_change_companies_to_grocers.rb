class ChangeCompaniesToGrocers < ActiveRecord::Migration[6.1]
  def change
    rename_table :companies, :grocers
  end
end
