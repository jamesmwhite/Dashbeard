class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :rssfeed
      t.string :stocksymbol
      t.string :weathercode
      t.string :trainstationcode
      t.integer :busstationcode
      t.integer :refreshfrequency

      t.timestamps null: false
    end
  end
end
