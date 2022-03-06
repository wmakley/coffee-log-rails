# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@coffee-log-rails.herokuapp.com'
  layout 'mailer'
end
