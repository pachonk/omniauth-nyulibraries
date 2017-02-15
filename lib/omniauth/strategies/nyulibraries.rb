module OmniAuth
  module Strategies
    require 'omniauth-oauth2'
    class Nyulibraries < OmniAuth::Strategies::OAuth2
      if defined?(::Rails) && ::Rails.env.development?
        silence_warnings do
          OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
        end
      end
      option :name, :nyulibraries

      option :client_options, {
        site: "http://localhost:3001",
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
          last_name: last_name,
          first_name: first_name
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

      # Pass querystring from client to provider
      def authorize_params
        querystring_hash = Rack::Utils.parse_nested_query(request.query_string[/institution=(\w+)/,0])
        super.merge(querystring_hash)
      end

      # Get the provider's identity
      def provider_identity
        @provider_identity ||= raw_info["identities"].find {|id| id["provider"] == raw_info["provider"]}
      end

      # Extract Last Name from identity
      def last_name
        @last_name ||= provider_identity["properties"]["last_name"] rescue nil
      end

      # Extract First Name from identity
      def first_name
        @first_name ||= provider_identity["properties"]["first_name"] rescue nil
      end
    end
  end
end
