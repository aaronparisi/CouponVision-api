class CreateGrocerBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :grocer_brands do |t|
      t.references :grocer, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
