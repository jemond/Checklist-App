class Checklist < ActiveRecord::Base
	validates_presence_of :list, :message => 'can\'t be blank'
	
	# we split off a bunch of stuff automagically from the list body to make it easier to use for the user
	def self.get_title_from_list list
		@lines = list.split("\n")
		return @lines[0]
	end
	
	# the last line of a checklist should contain emails to send the checklist to.
	# if it doesn't, then it's the last checklist item
	def self.get_emails_from_list list
		if(list.kind_of?(Array))
			lastline = list.last
		else
			lastline = list.split("\n").last
		end
		
		return is_email_list lastline.strip
	end
	
	# is a list of emails actually emails?
	def self.is_email_list emails
		#if it's a list, check each one
		emails = emails.split(/, */ )
		if(emails.kind_of?(Array))
			emails.each do |email|
				unless is_email email
					emails = nil
					break # since we don't care if more than one entry is bad
				end
			end
			
			unless emails.nil?
				emails = emails.join(', ')
			end
		else
			unless is_email emails
				emails = nil
			end
		end
		
		return emails
	end
	
	# check if a little email is valid
	def self.is_email email
		return email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/ ? true : false
	end
	
	# pull out parts from the list we don't need
	def self.prepare_list checklist
		#make an array
		checklist.list = checklist.list.lines.to_a
		
		# the first line is always the title
		checklist.list = checklist.list[1..-1]
		
		# the last line might be emails, which is optional
		checklist.list = ( ( get_emails_from_list checklist.list) != '' ) ? checklist.list[0..-2] : checklist.list
		
		# remove the optional line numbers the user might enter so we can build it out in the view
		# make it an array so we can output cleanly in the view		
		checklist.list.each_with_index do |item,i|
			checklist.list[i] = item.gsub(/[0-9]+[ ]?[\.]?[\-]?/,'')
		end
		
		return checklist
	end
	
	def self.prepare_lists checklists
		checklists.each_with_index do |list,i|
			checklists[i] = Checklist.prepare_list list
			checklists[i].list = checklists[i].list[1..3]
		end
		
		return checklists
	end
end