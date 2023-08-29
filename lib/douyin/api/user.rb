# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module Api
    class User < Base

      include Methods::User

      attr_reader :app, :open_id

      def initialize(app:, open_id:)
        @app = app
        @open_id = open_id
      end

      def init(refresh_token, expires_in)
        token_store.init_refresh_token(refresh_token, expires_in)
      end

      private

      def token_store
        @token_store ||= TokenStore::UserToken.new(self)
      end

    end
  end
end