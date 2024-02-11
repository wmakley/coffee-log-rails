# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  extend T::Sig
  default from: "noreply@coffee-log.willmakley.dev"
  layout "mailer"
end
