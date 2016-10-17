class RemoveStringFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :string, :string
  end
end
