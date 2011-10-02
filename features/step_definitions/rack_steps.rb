require 'rack'

Given /^I have a rack application "([^"]*)"$/ do |app|
   testfile_exists?(app).should be_true 
end

Given /^the rack test app is running$/ do
  config_file = File.read("test_objects/config.ru")
  rack_application = eval("Rack::Builder.new { #{config_file} }")
  start_server(3000,rack_application)
end

Given /^the rails test app is running$/ do
  current_dir = Dir.pwd
  Dir.chdir("test_objects/rails_test")
  config_file = File.read("config.ru")
  rack_application = eval("Rack::Builder.new { #{config_file} }")
  start_server(3000,rack_application)
  Dir.chdir(current_dir)
end
