if defined?(Sentry) && (sentry_dsn = Rails.application.credentials.dig(Rails.env.to_sym, :sentry, :dsn)).present?
  Sentry.init do |config|
    config.dsn = sentry_dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set tracesSampleRate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production
    # config.traces_sample_rate = 1.0
    # or
    config.traces_sampler = lambda do |context|
      false
    end
  end
end
