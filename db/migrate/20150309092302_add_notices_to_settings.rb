class AddNoticesToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :notices, :text
  end
end
