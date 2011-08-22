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
