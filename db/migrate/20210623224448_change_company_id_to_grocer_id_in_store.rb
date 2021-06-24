class ChangeCompanyIdToGrocerIdInStore < ActiveRecord::Migration[6.1]
  def change
    remove_reference :stores, :company, index: true
    add_reference :stores, :grocer, index: true, foreign_key: true
  end
end
