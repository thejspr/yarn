Then /^the log should contain "([^"]*)"$/ do |message|
  @output.messages.should include(message)
end 

When /^I debug "([^"]*)"$/ do |message|
  Logger.debug message 
end
