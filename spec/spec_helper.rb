$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
  add_filter "lib/rack/handler/"
end

require 'yarn'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers
end
