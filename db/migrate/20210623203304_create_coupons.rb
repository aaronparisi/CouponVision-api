class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :savings
      t.decimal :cash_value
      t.date :expiration_date

      t.timestamps
    end
  end
end
