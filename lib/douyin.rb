# frozen_string_literal: true

require_relative "douyin/version"
require 'redis'
require 'active_support/all'
require 'douyin/config'
require 'douyin/exceptions'
douyin_lib_path = "#{File.dirname(__FILE__)}/douyin"
Dir["#{douyin_lib_path}/api/methods/*.rb"].each { |path| require path }

require 'douyin/token_store/base'
require 'douyin/token_store/app_token'
require 'douyin/token_store/user_token'
require 'douyin/api/base'
require 'douyin/api/app'
require 'douyin/api/user'