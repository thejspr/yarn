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
  @server.start port
end

Then /^I should see "([^"]*)"$/ do |message|
  output.messages.should include(message)
end

When /^I stop the server$/ do
  @server.stop unless @server.nil?
end

Given /^the server is running$/ do
  @server = ThreadedServer::Server.new(output)
  @server.start
end

Given /^the server is not running$/ do
  @server.stop unless @server.nil?
  @server = nil
end

Given /^the file "([^"]*)" exist$/ do |file|
  f = File.new File.join(File.join(File.dirname(__FILE__), "/../../"), file)
  File.exists?(f).should be_true
end

Given /^the file "([^"]*)" does not exist$/ do |file|
  File.exists?(File.join(File.join(File.dirname(__FILE__), "/../../"), file)).should be_false
end

