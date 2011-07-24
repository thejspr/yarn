$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'rubygems'
require 'capybara/cucumber'

require 'threaded_server'
require 'threaded_server/logger'
require 'threaded_server/helpers'

Capybara.default_driver = :selenium
