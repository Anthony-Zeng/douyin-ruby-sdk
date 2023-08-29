# @author anthony
# @date  2023/8/29
# @desc 
module Douyin
  class AccessTokenExpiredError < RuntimeError; end

  class SystemBusyException < RuntimeError; end

  class ResponseError < StandardError
    attr_reader :error_code

    def initialize(errcode, errmsg = "")
      @error_code = errcode
      super "(#{error_code}) #{errmsg}"
    end
  end
end