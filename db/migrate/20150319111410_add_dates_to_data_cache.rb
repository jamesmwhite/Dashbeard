class AddDatesToDataCache < ActiveRecord::Migration
  def change
    add_column :data_caches, :stockDate, :datetime
    add_column :data_caches, :rssDate, :datetime
    add_column :data_caches, :trainDate, :datetime
    add_column :data_caches, :busDate, :datetime
  end
end
