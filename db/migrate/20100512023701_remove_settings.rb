class RemoveSettings < ActiveRecord::Migration
  def self.up
    drop_table :settings
  end

  def self.down
  end
end
