include Helpers

When /^I start the server on port (\d+)$/ do |port|
  @output = capture(:stdout) { start_server port }
end

When /^I stop the server$/ do
  @output = capture(:stdout) { stop_server unless @server.nil? }
end

Given /^the server is running$/ do
  start_server
end

Given /^the server is running as static$/ do
  start_server
end

Given /^the server is not running$/ do
  stop_server unless @server.nil?
  @server = nil
end

Given /^the file "([^"]*)" exist$/ do |file|
  f = File.new File.join(File.join(File.dirname(__FILE__), "/../../"), "test_objects/#{file}")
  File.exists?(f).should be_true
end

Given /^the file "([^"]*)" does not exist$/ do |file|
  File.exists?(File.join(File.join(File.dirname(__FILE__), "/../../"), "test_objects/#{file}")).should be_false
end

When /^I log "([^"]*)"$/ do |message|
  @output = capture(:stdout) { @server.log message }
end

When /^I debug "([^"]*)"$/ do |message|
  @output = capture(:stdout) { @server.debug message }
end

Then /^I should see "([^"]*)"$/ do |message|
  @output.include? message
end
