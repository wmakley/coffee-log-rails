Rails.configuration.after_initialize do
  if Rails.env.development?
    # Do not allow banning localhost in development (very annoying if you are testing login behavior)
    Fail2Ban.whitelist << "127.0.0.1"
    Fail2Ban.whitelist << "::1"
  end

  Rails.logger.info "Fail2Ban whitelist: #{Fail2Ban.whitelist.inspect}"
end
