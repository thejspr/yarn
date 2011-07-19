$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'threaded_server'
require 'capybara/cucumber'

Capybara.default_driver = :webkit
