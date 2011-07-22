include Helpers

class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end

def output
  @output ||= Output.new
end

When /^I start the server on port (\d+)$/ do |port|
  @server = ThreadedServer::Server.new(output)
  start_server('localhost',port)
end

Then /^I should see "([^"]*)"$/ do |message|
  output.messages.should include(message)
end

When /^I stop the server$/ do
  stop_server unless @server.nil?
end

Given /^the server is running$/ do
  @server = ThreadedServer::Server.new(output)
  start_server
end

Given /^the server is not running$/ do
  stop_server unless @server.nil?
  @server = nil
end

Given /^the file "([^"]*)" exist$/ do |file|
  f = File.new File.join(File.join(File.dirname(__FILE__), "/../../"), file)
  File.exists?(f).should be_true
end

Given /^the file "([^"]*)" does not exist$/ do |file|
  File.exists?(File.join(File.join(File.dirname(__FILE__), "/../../"), file)).should be_false
end

When /^I debug "([^"]*)"$/ do |message|
  @server.debug message
end
