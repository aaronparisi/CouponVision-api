class AddStoreReferenceToCoupons < ActiveRecord::Migration[6.1]
  def change
    add_reference :coupons, :store, index: true, foreign_key: true
  end
end
