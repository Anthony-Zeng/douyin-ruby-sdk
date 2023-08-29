# frozen_string_literal: true

require_relative "lib/douyin/version"

Gem::Specification.new do |spec|
  spec.name = "douyin"
  spec.version = Douyin::VERSION
  spec.authors = ["anthony"]
  spec.email = ["zengkun@netfarmer.com.cn"]

  spec.summary = "自己使用"
  spec.description = "自己使用"
  spec.homepage = "https://github.com/Anthony-Zeng/douyin-ruby-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'http', '>= 2.2'
  spec.add_dependency 'activesupport', '>= 5.0'
  spec.add_dependency 'redis'

  spec.add_development_dependency "bundler", ">= 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.10"


end
