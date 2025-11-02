require Rails.root.join('lib/omniauth/strategies/authentik').to_s

# Configure OmniAuth to use POST only for security
OmniAuth.config.allowed_request_methods = [:post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :authentik,
           ENV['AUTHENTIK_CLIENT_ID'],
           ENV['AUTHENTIK_CLIENT_SECRET'],
           scope: 'openid profile email'
end
