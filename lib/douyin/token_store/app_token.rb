# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module TokenStore
    class AppToken < Base

      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def fetch_token
        client.request.post 'oauth/client_token/', {
          client_secret: client.client_secret,
          grant_type: 'client_credential',
          client_key: client.client_key
        }
      end

      def token_key
        "access_token"
      end

      def redis_key
        @redis_key ||= Digest::MD5.hexdigest "DY_APP_TOKEN_#{client.client_key}_#{client.client_secret}"
      end

    end
  end
end
