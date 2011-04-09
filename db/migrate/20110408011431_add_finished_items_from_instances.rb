class AddFinishedItemsFromInstances < ActiveRecord::Migration
	def self.up
		add_column :instances, :finished_items, :string
	end
	
	def self.down
		remove_column :instances, :finished_items
	end
end
