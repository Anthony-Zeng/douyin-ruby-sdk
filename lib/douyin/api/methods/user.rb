# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  module Api
    module Methods
      module User
        def user_info
          post 'oauth/userinfo/', {
            access_token: access_token,
            open_id: open_id
          }
        end

      end
    end
  end
end
