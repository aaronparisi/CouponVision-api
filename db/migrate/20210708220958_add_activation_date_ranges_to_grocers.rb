class AddActivationDateRangesToGrocers < ActiveRecord::Migration[6.1]
  def change
    add_column :grocers, :earliest_activation_date, :date
    add_column :grocers, :latest_activation_date, :date
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
