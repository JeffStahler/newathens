class DropSubscriptions < ActiveRecord::Migration
  def self.up
    drop_table :subscriptions
  end

  def self.down
  end
end
