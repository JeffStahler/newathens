class DropEvents < ActiveRecord::Migration
  def self.up
    drop_table :events
  end

  def self.down
  end
end
