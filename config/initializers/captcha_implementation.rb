Rails.application.config.to_prepare do
  CaptchaWrapper.captcha_implementation =
    if Rails.env.local?
      :always_succeed
    else
      :production
    end
end
