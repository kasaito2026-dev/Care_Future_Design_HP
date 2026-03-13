class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("ADMIN_EMAIL", "info@kaigo-society.org").downcase
  layout "mailer"
end
