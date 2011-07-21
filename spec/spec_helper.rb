$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'
require 'capybara/rspec'

require 'threaded_server'
require 'threaded_server/logger'
require 'threaded_server/version'
require 'threaded_server/helpers'

RSpec.configure do |config|
  config.include Helpers
end
