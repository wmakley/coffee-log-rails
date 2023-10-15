Rails.configuration.after_initialize do
  case Rails.env.to_sym
  when :development
    # Do not allow banning localhost in development (very annoying if you are testing login behavior)
    Fail2Ban.whitelist = ["127.0.0.1"]
  else
    Fail2Ban.whitelist = []
  end
end
