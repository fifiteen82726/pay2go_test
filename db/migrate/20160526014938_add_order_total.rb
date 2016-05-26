class AddOrderTotal < ActiveRecord::Migration
  def change
  	 add_column :orders, :total, :integer, default: 100
  end
end
