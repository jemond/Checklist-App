class AddEmailsToInstances < ActiveRecord::Migration
	def self.up
		add_column :instances, :emails, :string
	end
	
	def self.down
		remove_column :instances, :emails, :string
	end
end
