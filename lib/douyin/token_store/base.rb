# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module TokenStore
    class Base
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def token
        update_token if expired?
        redis.hget(redis_key, token_key)
      end

      def update_token
        data = fetch_token.data
        value = data[token_key] || data.dig('data', token_key)
        if value.nil?
          Rails.logger.error "#{self.class.name} fetch token error: #{data.inspect}"
        else
          expires_in = data.dig('data', 'expires_in')
          expires_in = 7200 if expires_in.nil?
          expires_at = Time.now.to_i + expires_in.to_i - 120
          redis.hmset(
            redis_key,
            token_key, value,
            'expires_at', expires_at
          )
          redis.expireat(redis_key, expires_at)
        end
        value
      end

      private

      def redis
        Redis::Alfred
      end

      def redis_key
        raise NotImplementedError
      end

      def token_key
        'access_token'
      end

      def fetch_token
        raise NotImplementedError
      end

      def expired?
        redis.hvals(redis_key).empty? || redis.hget(redis_key, 'expires_at').to_i <= Time.now.to_i
      end
    end
  end
end
