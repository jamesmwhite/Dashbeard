class ChangeOtherTypesToTextInCache < ActiveRecord::Migration
  def change
  	change_column :data_caches, :train,  :text
  	change_column :data_caches, :bus,  :text
  end
end
