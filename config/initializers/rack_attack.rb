class Rack::Attack
  # Configure cache store (uses Rails.cache by default)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Allow requests from localhost in development
  safelist('allow-localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1' if Rails.env.development?
  end

  # Throttle general requests by IP
  # Limit: 300 requests per 5 minutes per IP
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  # Throttle link creation endpoints more aggressively
  # Limit: 10 link creations per minute per IP
  throttle('links/create/ip', limit: 10, period: 1.minute) do |req|
    if req.post? && (req.path == '/links' || req.path == '/quick_create')
      req.ip
    end
  end

  # Throttle redirect lookups to prevent enumeration
  # Limit: 60 redirect lookups per minute per IP
  throttle('redirects/ip', limit: 60, period: 1.minute) do |req|
    if req.get? && !req.path.start_with?('/links', '/settings', '/auth', '/login', '/logout', '/search', '/rails', '/assets')
      req.ip
    end
  end

  # Throttle login attempts
  # Limit: 5 login attempts per 20 seconds per IP
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/auth/authentik' && req.post?
      req.ip
    end
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |request|
    match_data = request.env['rack.attack.match_data']
    
    headers = {
      'Content-Type' => 'text/html',
      'Retry-After' => (match_data[:period] || 60).to_s
    }

    [
      429,
      headers,
      ["<html><body><h1>Rate Limit Exceeded</h1><p>Too many requests. Please try again later.</p></body></html>"]
    ]
  end

  # Log blocked requests
  ActiveSupport::Notifications.subscribe('throttle.rack_attack') do |name, start, finish, request_id, payload|
    req = payload[:request]
    Rails.logger.warn "[Rack::Attack] Throttled #{req.ip} for #{req.path}"
  end
end
