class CreateCouponStores < ActiveRecord::Migration[6.1]
  def change
    create_table :coupon_stores do |t|
      t.references :coupon, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
