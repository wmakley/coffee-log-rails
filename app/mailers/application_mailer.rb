# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "noreply@coffee-log.willmakley.dev"
  layout "mailer"
end
