class CreatePhotoLinks < ActiveRecord::Migration
  def change
    create_table :photo_links do |t|
      t.string :url
      t.boolean :hidden

      t.timestamps null: false
    end
  end
end
