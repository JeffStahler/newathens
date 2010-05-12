class DropArticles < ActiveRecord::Migration
  def self.up
    drop_table :articles
  end

  def self.down
  end
end
