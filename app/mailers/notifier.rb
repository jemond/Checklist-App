class Notifier < ActionMailer::Base
	default :from => 'Checklist App <info@checklistapp>'
	
	def checklist_finished title, email
		@title = title.strip
		
		mail :to => email, :subject => 'Checklist "' + @title + '" finished!'	
	end
end