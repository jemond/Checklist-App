class Checklist < ActiveRecord::Base
	validates_presence_of :list, :message => 'can\'t be blank'
	
	# we split off a bunch of stuff automagically from the list body to make it easier to use
	def self.get_title_from_list (list)
		@lines = list.split("\n")
		return @lines[0]
	end
	
	def self.get_emails_from_list (list)
		@lines = list.split("\n")
		return @lines.last
	end
end
