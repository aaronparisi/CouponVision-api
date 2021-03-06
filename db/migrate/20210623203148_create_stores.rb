class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
