# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module TokenStore
    class UserToken < Base

      def fetch_token
        client.request.post_form_urlencoded "oauth/refresh_token/", {
          client_key: client.app.client_key,
          grant_type: 'refresh_token',
          refresh_token: refresh_token
        }
      end

      def init_refresh_token(refresh_token, expires_at)
        expires_at = Time.now.to_i + expires_at.to_i - 120
        redis.hmset(
          refresh_redis_key,
          refresh_token_key, refresh_token,
          'expires_at', expires_at
        )
        redis.expireat(refresh_redis_key, expires_at)
      end

      def refresh_token
        update_refresh_token if refresh_expired?
        refresh_token_vals
      end

      def refresh_expired?
        redis.hvals(refresh_redis_key).empty? || redis.hget(refresh_redis_key, 'expires_at').to_i <= Time.now.to_i
      end

      def update_refresh_token
        data = fetch_refresh_token.data
        value = data[refresh_token_key] || data.dig('data', refresh_token_key)
        if value.nil?
          Rails.logger.error "#{self.class.name} fetch refresh token error: #{data.inspect}"
        else
          expires_in = data.dig('data', 'expires_in')
          expires_in = 7200 if expires_in.nil?
          expires_at = Time.now.to_i + expires_in.to_i - 120
          redis.hmset(
            refresh_redis_key,
            refresh_token_key, value,
            'expires_at', expires_at
          )
          redis.expireat(refresh_redis_key, expires_at)
        end
        value
      end

      def fetch_refresh_token
        client.request.post_form_urlencoded "oauth/renew_refresh_token/", {
          client_key: client.app.client_key,
          refresh_token: refresh_token_vals
        }
      end

      def refresh_token_vals
        redis.hget(refresh_redis_key, refresh_token_key)
      end

      def token_key
        'access_token'
      end

      def refresh_token_key
        'refresh_token'
      end

      def redis_key
        @redis_key ||= Digest::MD5.hexdigest "DY_USER_TOKEN_#{client.open_id}"
      end

      def refresh_redis_key
        @refresh_redis_key ||= Digest::MD5.hexdigest "DY_USER_REFRESH_TOKEN_#{client.open_id}"
      end

    end
  end
end
