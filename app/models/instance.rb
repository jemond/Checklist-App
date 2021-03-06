class Instance < ActiveRecord::Base
	serialize :finished_items
	
	# determine if we need a new instance or not for a user checking off an item
	def self.exists checklist_id
		#instance = Instance.find(:first, :select => 'id, finished_items, updated_at, emails, list', :conditions => ['checklist_id = ? and finished <> ?',checklist_id,true ], :order=>'created_at DESC', :limit=>1)
		instance = Instance.select('id, finished_items, updated_at, emails, list').where(:checklist_id => checklist_id, :finished => false).order('created_at DESC')
		
		return instance.empty? ? false : instance[0]
	end
	
	# setup a new instance when one doesn't exist for a user and they check their first item
	def self.create checklist
		@instance = Instance.new(:emails=>checklist.emails, :list=>checklist.list, :finished=>0, :checklist_id=>checklist.id)
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
		finished_items = finished_items.nil? ? [] : finished_items
		
		# if it's not there, add it (a check); otherwise, remove it (an uncheck)
		finished_items.include?(item) ? finished_items.delete(item) : finished_items.push(item)
		
		# save it to the instance	
		Instance.update(instance_id, :finished_items=>finished_items)
		
		# give back the new finished_items
		return finished_items
	
	end
	
	# finish the checklist, by marking it finished
	def self.finish instance
		instance.update_attribute 'finished', true
	end
	
	# get the old instances to show to the user when filling out a new one
	def self.get_previous checklist_id
		return Instance.select('updated_at').where(:checklist_id=>checklist_id, :finished=> true).order('created_at DESC')
	end	
end