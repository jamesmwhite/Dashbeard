class CreateDataCaches < ActiveRecord::Migration
  def change
    create_table :data_caches do |t|
      t.string :stock
      t.string :rss
      t.string :bus
      t.string :train

      t.timestamps null: false
    end
  end
end
