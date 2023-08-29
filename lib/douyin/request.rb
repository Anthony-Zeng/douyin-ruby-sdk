# @author anthony
# @date  2023/8/29
# @desc
require 'http'
module Douyin
  class Request

    attr_reader :ssl_context, :http

    def initialize(skip_verify_ssl = true)
      @http = HTTP.timeout(write: 15, read: 15, connect: 10)
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.ssl_version = :TLSv1_2
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE if skip_verify_ssl
    end

    def get(path, get_header = {})
      request(path, get_header) do |url, header|
        params = header.delete(:params)
        http.headers(header).get(url, params: params, ssl_context: ssl_context)
      end
    end

    def delete(path, delete_body, delete_header = {})
      request(path, delete_header) do |url, header|
        params = header.delete(:params)
        http.headers(header).delete(url, params: params, json: delete_body, ssl_context: ssl_context)
      end
    end

    def post(path, post_body, post_header = {})
      request(path, post_header) do |url, header|
        Douyin.logger.info "payload: #{post_body}"
        params = header.delete(:params)
        http.headers(header).post(url, params: params, json: post_body, ssl_context: ssl_context)
      end
    end

    def post_form(path, form_data, post_header = {})
      request(path, post_header) do |url, header|
        header.delete(:params)
        http.headers(header).post(
          url,
          form: HTTP::FormData::Multipart.new(form_data),
          ssl_context: ssl_context
        )
      end
    end

    def put(path, put_body, put_header = {})
      request(path, put_header) do |url, header|
        params = header.delete(:params)
        http.headers(header).put(url, params: params, json: put_body, ssl_context: ssl_context)
      end
    end

    private

    def request(path, header = {}, &_block)
      url = URI.join(Douyin.api_base_url, path)
      as = header.delete(:as)
      header['Accept'] = 'application/json'
      header['Content-Type'] = 'application/json' if header['Content-Type'].blank?
      header_params = header.fetch(:params, {})
      request_uuid = SecureRandom.uuid
      header['X-Request-ID'] = request_uuid
      header[:params] = header_params
      response = yield(url, header)
      if response.status.success?
        handle_response(response, as || :json)
      elsif response.status.server_error?
        handle_response(response, as || :json)
      else
        handle_response(response, as || :json)
      end

    end

    def handle_response(response, as)
      content_type = response.headers[:content_type]
      parse_as = {
        %r{^application\/json} => :json,
        %r{^image\/.*} => :file
      }.each_with_object([]) { |match, memo| memo << match[1] if content_type =~ match[0] }.first || as || :text

      body = response.body
      case parse_as
      when :file
        parse_as_file(body)
      when :json
        parse_as_json(body)
      else
        body
      end
    end

    def parse_as_json(body)
      data = JSON.parse body.to_s
      result = Result.new(data)
      raise ::Douyin::AccessTokenExpiredError if result.access_token_expired?
      raise ::Douyin::SystemBusyException if result.system_busy?

      result
    end

    def parse_as_file(body)
      file = Tempfile.new('tmp')
      file.binmode
      file.write(body)
      file.close
      file
    end

  end

  class Result
    attr_reader :code, :data

    def initialize(data)
      @code = data['data']['error_code'].to_i
      @data = data
    end

    def access_token_expired?
      [10_008, 2_190_002, 2_190_008].include?(code)
    end

    def system_busy?
      [2_100_004].include?(code)
    end

    def success?
      code.zero?
    end

  end
end
