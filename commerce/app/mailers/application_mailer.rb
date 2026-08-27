class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM_ADDRESS", "noreply@valdra.test")
  layout "mailer"
end
