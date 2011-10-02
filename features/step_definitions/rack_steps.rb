require 'rack'

Given /^I have a rack application "([^"]*)"$/ do |app|
   testfile_exists?(app).should be_true 
end

Given /^the rack test app is running$/ do
  start_server(3000,"test_objects/config.ru")
end

Given /^the rails test app is running$/ do
  current_dir = Dir.pwd
  Dir.chdir("test_objects/rails_test")
  start_server(3000,"config.ru")
  Dir.chdir(current_dir)
end
