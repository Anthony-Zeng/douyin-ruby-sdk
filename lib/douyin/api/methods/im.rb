# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
    module Api
      module Methods
        module Im

					def send_text_message(open_id:, conversation_id:, to_user_id:, msg_id:, text: , scene: nil)
						send_message(open_id, conversation_id, to_user_id, msg_id, {
							msg_type: 1,
							text: {
								text: text
							}
						}, scene)
					end

					def send_image_message(open_id:, conversation_id:, to_user_id:, msg_id:, media_id: , scene: nil)
						send_message(open_id, conversation_id, to_user_id, msg_id, {
							msg_type: 2,
							image: {
								media_id: media_id
							}
						}, scene)
					end

					def send_video_message(open_id:, conversation_id:, to_user_id:, msg_id:, item_id: , scene: nil)
						send_message(open_id, conversation_id, to_user_id, msg_id, {
							msg_type: 3,
							video: {
								item_id: item_id
							}
						}, scene)
					end

					def send_card_message(open_id:, conversation_id:, to_user_id:, msg_id:, card_id: , scene: nil)
						send_message(open_id, conversation_id, to_user_id, msg_id, {
							msg_type: 8,
							retain_consult_card: {
								card_id: card_id
							}
						}, scene)
					end

					private

          def send_message(open_id, conversation_id, to_user_id, msg_id, payload = {}, scene = nil)
						post "im/send/msg/?open_id=#{open_id}", {
							content: payload,
							msg_id: msg_id,
							conversation_id: conversation_id,
							to_user_id: to_user_id,
							scene: scene
						}.compact
					end
          
          
        end
      end
    end
  end