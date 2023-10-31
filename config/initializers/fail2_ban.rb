Rails.configuration.after_initialize do
  Fail2Ban.whitelist = case Rails.env.to_sym
  when :development
    # Do not allow banning localhost in development (very annoying if you are testing login behavior)
    ["127.0.0.1"]
  else
    []
  end
end
