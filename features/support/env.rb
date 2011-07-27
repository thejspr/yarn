$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
$LOAD_PATH << File.expand_path('../../../spec', __FILE__)

require 'rubygems'
require 'capybara/cucumber'

require 'yarn'
require 'yarn/logger'
require 'helpers'

Capybara.default_driver = :selenium
