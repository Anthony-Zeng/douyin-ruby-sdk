# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module Api
    class App < Base

      include Douyin::Cipher
      include Methods::App

      attr_reader :client_key, :client_secret

      def initialize(client_key:, client_secret:)
        @client_key = client_key
        @client_secret = client_secret
      end

      def user(open_id)
        Douyin::Api::User.new(app: self, open_id: open_id)
      end

      private

      def token_store
        @token_store ||= TokenStore::AppToken.new self
      end

    end
  end
end