# frozen_string_literal: true

# Wrapper for recaptcha gem to allow changing implementations and adding
# shared logic.
module CaptchaWrapper
  extend ActiveSupport::Concern

  mattr_accessor :captcha_implementation

  class CaptchaResult
    def initialize(success:, result:)
      @success = success
      @result = result
    end

    def success?
      @success
    end

    attr_reader :result

    def on_success
      yield @result if success?
      self
    end

    def on_failure
      yield @result if !success?
      self
    end
  end

  def verify_captcha(action:, minimum_score: 0.5)
    case captcha_implementation
    when :always_succeed
      CaptchaResult.new(success: true, result: nil)
    when :always_fail
      CaptchaResult.new(success: false, result: nil)
    when :production
      success = verify_recaptcha(action:, minimum_score:)
      logger.info "ReCAPTCHA success: #{success}"
      if !success
        logger.warn "ReCAPTCHA reply is nil" if recaptcha_reply.nil?
        score = recaptcha_reply["score"] if recaptcha_reply
        logger.info("User was denied '#{action}' because of a ReCAPTCHA score of #{score.inspect} | reply: #{recaptcha_reply.inspect}")
      end

      CaptchaResult.new(success: success, result: recaptcha_reply)
    else
      raise "unknown CAPTCHA implementation: #{captcha_implementation.inspect}"
    end
  end
end
