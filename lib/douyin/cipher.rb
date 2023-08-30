require 'openssl/cipher'
require 'base64'
module Douyin
  module Cipher
    
    CIPHER = 'AES-256-CBC'.freeze

    def decrypt(msg)
      decipher = OpenSSL::Cipher.new(CIPHER)
      decipher.decrypt
      decipher.key = client_secret
      decipher.iv = client_secret[0,16]
      decipher.update(Base64.decode64(msg)) + decipher.final
    end
    
    def signature(body)
      Digest::SHA1.hexdigest("#{client_secret}#{body}")
    end
    
  end
end
