# frozen_string_literal: true

# ApplicationMailer is the base class for all mailers in the application.
# It defines default behavior such as layout and sender email.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
