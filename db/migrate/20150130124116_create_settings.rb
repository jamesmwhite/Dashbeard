class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :rssfeed
      t.string :stocksymbol
      t.string :weathercode
      t.string :trainstation
      t.integer :busstopcode
      t.integer :refreshtime

      t.timestamps null: false
    end
  end
end
