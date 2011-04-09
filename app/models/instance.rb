class Instance < ActiveRecord::Base
	serialize :finished_items
	
	# determine if we need a new instance or not for a user checking off an item
	def self.exists checklist_id
		instance = Instance.find(:all, :select => 'id, finished_items, updated_at', :conditions => ['checklist_id = ? and finished <> ?',checklist_id,1 ], :order=>'created_at DESC', :limit=>1)
		
		return instance.empty? ? false : instance[0]
	end
	
	# setup a new instance when one doesn't exist for a user and they check their first item
	def self.create checklist
		@instance = Instance.new(:list=>checklist.list, :finished=>0, :checklist_id=>checklist.id)
		@instance.save
		
		return @instance
	end
	
	# wrapper for getting an instance, will create if needed
	def self.get_or_create checklist_id		
		unless instance = (Instance.exists checklist_id)
			instance = Instance.create Checklist.find(checklist_id)
		end
		
		return instance
	end
	
	# for a newly finished item it append it
	def self.update_finished_items instance_id, finished_items, item
		# if it isn't an array
		finished_items = finished_items.nil? ? Array.new : finished_items
		
		# if it's there, add it (a check); otherwise, remove it (an uncheck)
		finished_items.include?(item) ? finished_items.delete(item) : finished_items.push(item)
		
		# save it to the instance
		@instance = Instance.find(instance_id)
		return @instance.update_attribute 'finished_items', finished_items
	end
end