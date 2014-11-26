module OmniAuth
  module Strategies
    require 'omniauth-oauth2'
    class Nyulibraries < OmniAuth::Strategies::OAuth2
      if defined?(::Rails) && ::Rails.env.development?
        OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      end
      option :name, :nyulibraries

      option :client_options, {
        site: "https://dev.login.library.nyu.edu",
        authorize_path: "/oauth/authorize"
      }

      uid do
        raw_info["username"]
      end

      info do
        {
          name: raw_info["username"],
          nickname: raw_info["username"],
          email: raw_info["email"],
          first_name: raw_info["first_name"],
          last_name: raw_info["last_name"],
        }
      end
      extra do
        {
          provider: raw_info["provider"],
          identities: raw_info["identities"],
          institution_code: raw_info["institution_code"]
        }
      end

      def raw_info
        response = access_token.get("/api/v1/user")
        @raw_info ||= response.parsed
      end
    end
  end
end
