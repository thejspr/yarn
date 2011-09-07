$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'rubygems'
require 'fakefs'

unless /jruby/ =~ `ruby -v`
  require 'simplecov'
  SimpleCov.start do
    FakeFS.deactivate!
    add_filter "/spec/"
    add_filter "lib/yarn/http*"
  end
end

require 'bundler/setup'
require 'capybara/rspec'

require 'yarn'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers
end
