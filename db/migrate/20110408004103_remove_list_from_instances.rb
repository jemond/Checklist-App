class RemoveListFromInstances < ActiveRecord::Migration
  def self.up
    remove_column :instances, :list
  end

  def self.down
    add_column :instances, :list, :text
  end
end
