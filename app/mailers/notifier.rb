class Notifier < ActionMailer::Base
	default :from => 'Checklist App <info@checklistapp>'
	
	def checklist_finished title, emails
		@title = title.strip!
		
		mail :to => emails, :subject => 'Checklist "' + @title + '" finished!'
	end
end