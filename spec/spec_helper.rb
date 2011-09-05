$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'rubygems'
require 'simplecov'
require 'fakefs'

SimpleCov.start do
  FakeFS.deactivate!
  add_filter "/spec/"
  add_filter "lib/yarn/http*"
end

require 'bundler/setup'
require 'capybara/rspec'

require 'yarn'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers
end
