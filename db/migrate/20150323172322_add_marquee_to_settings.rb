class AddMarqueeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :marquee, :string
  end
end
