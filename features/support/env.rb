$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
$LOAD_PATH << File.expand_path('../../../spec', __FILE__)

require 'rubygems'

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-webkit'

require 'yarn'
require 'helpers'

Capybara.javascript_driver = :webkit
Capybara.default_driver = :webkit

Capybara.run_server = false
Capybara.app_host = "http://127.0.0.1:3000"

Capybara.default_wait_time = 5
