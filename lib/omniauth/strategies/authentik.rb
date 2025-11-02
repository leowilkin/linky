require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Authentik < OmniAuth::Strategies::OAuth2
      option :name, 'authentik'

      option :client_options, {
        site: ENV['AUTHENTIK_URL'],
        authorize_url: "#{ENV['AUTHENTIK_URL']}/application/o/authorize/",
        token_url: "#{ENV['AUTHENTIK_URL']}/application/o/token/",
        userinfo_url: "#{ENV['AUTHENTIK_URL']}/application/o/userinfo/",
        auth_scheme: :request_body
      }

      uid { raw_info['sub'] }

      info do
        {
          email: raw_info['email'],
          name: raw_info['name'] || raw_info['preferred_username']
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get(options[:client_options][:userinfo_url]).parsed
      end
      
      def callback_url
        # Return only the base callback URL without query parameters
        full_host + script_name + callback_path
      end
    end
  end
end
