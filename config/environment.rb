# Load the rails application
require File.expand_path('../application', __FILE__)

# Email
Cla::Application.configure do
	config.action_mailer.delivery_method = :smtp
	
	config.action_mailer.smtp_settings = {
		:address => "localhost",
		:port => 25,
		:domain => "checklistapp.com",
		:enable_starttls_auto => true
	}
end

# Initialize the rails application
Cla::Application.initialize!
