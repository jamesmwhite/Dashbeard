class AddPhotorefreshToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :photoRefresh, :integer
  end
end
