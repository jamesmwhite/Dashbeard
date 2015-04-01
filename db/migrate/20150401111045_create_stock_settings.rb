class CreateStockSettings < ActiveRecord::Migration
  def change
    create_table :stock_settings do |t|
      t.string :symbol

      t.timestamps null: false
    end
  end
end
