# @author anthony
# @date  2023/8/29
# @desc
require 'douyin/request'
module Douyin
  module Api
    class Base

      def request
        @request ||= Douyin::Request.new
      end

      def get(path, headers = {})
        with_token(headers) do |headers_with_token|
          request.get(path, headers_with_token)
        end
      end

      def delete(path, payload = {}, headers = {})
        with_token(headers) do |headers_with_token|
          request.delete path, payload, headers_with_token
        end
      end

      def post(path, payload = {}, headers = {})
        with_token(headers) do |headers_with_token|
          request.post path, payload, headers_with_token
        end
      end

      def post_form(path, form_data, headers = {})
        with_token(headers) do |headers_with_token|
          request.post_form path, form_data, headers_with_token
        end
      end

      def put(path, payload = {}, headers = {})
        with_token(headers) do |headers_with_token|
          request.put path, payload, headers_with_token
        end
      end

      def access_token
        token_store.token
      end

      private

      def token_store
        raise NotImplementedError
      end

      def token_params
        { "access-token" => access_token }
      end

      def with_token(headers = {}, tries = 2)
        headers ||= {}
        yield headers.merge(token_params)
        # rescue AccessTokenExpiredError
        # token_store.update_token
        # retry unless (tries -= 1).zero?
      end

    end
  end
end
