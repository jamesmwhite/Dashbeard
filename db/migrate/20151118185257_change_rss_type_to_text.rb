class ChangeRssTypeToText < ActiveRecord::Migration
  def change
  	change_column :data_caches, :rss,  :text
  end
end
