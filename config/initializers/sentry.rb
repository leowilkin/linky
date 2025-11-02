Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to enable performance monitoring
  # 0.1 = 10% of transactions, adjust as needed
  config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', '0.1').to_f

  # Add data like request headers and IP for users
  config.send_default_pii = true

  # Filter sensitive parameters
  config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']

  # Set environment
  config.environment = Rails.env

  # Only enable in production and staging
  config.enabled_environments = %w[production staging]
end
