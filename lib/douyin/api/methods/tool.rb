# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
    module Api
      module Methods
        module Tool
          def image_upload(image)
            post_form 'tool/imagex/client_upload/', {
                image: image
            }
          end
        end
      end
    end
  end
  