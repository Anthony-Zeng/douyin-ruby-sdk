# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module Api
    module Methods
      module App

        def authorize_url(redirect_uri, scope, state = 'douyin', optional_scope = '0')
          uri = ERB::Util.url_encode(redirect_uri)
          "https://open.douyin.com/platform/oauth/connect/?client_key=#{client_key}&response_type=code&scope=#{scope}&redirect_uri=#{uri}&state=#{state}&optionalScope=#{optional_scope}"
        end

        def get_auth_info(code)
          post 'oauth/access_token/', {
            code: code,
            client_secret: client_secret,
            grant_type: 'authorization_code',
            client_key: client_key
          }
        end
      end
    end
  end
end
