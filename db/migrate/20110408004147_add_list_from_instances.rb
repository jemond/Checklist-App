class AddListFromInstances < ActiveRecord::Migration
  def self.up
    add_column :instances, :list, :text
  end

  def self.down
    remove_column :instances, :list
  end
end
