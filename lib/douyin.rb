# frozen_string_literal: true

require_relative "douyin/version"
require 'redis'
require 'active_support/all'
require 'douyin/config'
require 'douyin/exceptions'
douyin_lib_path = "#{File.dirname(__FILE__)}/douyin"
Dir["#{douyin_lib_path}/api/methods/*.rb", "#{douyin_lib_path}/token/*.rb"].each { |path| require path }

require 'douyin/api/base'
require 'douyin/api/app'
require 'douyin/api/user'