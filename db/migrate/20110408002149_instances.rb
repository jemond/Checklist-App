class Instances < ActiveRecord::Migration
	def self.up
		create_table :instances do |t|
			t.primary_key  :id
			t.integer      :checklist_id, :user_id
			t.text         :list
			t.boolean      :finished
			t.timestamps
		end
	end
	
	def self.down
		drop_table :instances
	end
end
