include Helpers

When /^I start the server on port (\d+)$/ do |port|
  start_server port
end

When /^I stop the server$/ do
  stop_server unless @server.nil?
end

Given /^the server is running$/ do
  start_server(3000)
end

Given /^the server is not running$/ do
  stop_server unless @server.nil?
  @server = nil
end

Given /^the file "([^"]*)" exist$/ do |file|
  testfile_exists?(file).should be_true
end

Given /^the file "([^"]*)" does not exist$/ do |file|
  testfile_exists?(file).should be_false
end

When /^I log "([^"]*)"$/ do |message|
  @server.log message
end

When /^I debug "([^"]*)"$/ do |message|
  @server.debug message
end

Then /^I should see "([^"]*)"$/ do |message|
  $console.contains? message
end
