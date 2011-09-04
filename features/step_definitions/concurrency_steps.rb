Given /^a client "([^"]*)"$/ do |client|
  @clients ||= {}
  @clients[client] = Thread.new { @response = get "/" }
end

When /^client "([^"]*)" makes a "([^"]*)" request$/ do |client,speed|
  pending # express the regexp above with the code you wish you had
end

Then /^client "([^"]*)" receives a response before client "([^"]*)"$/ do |client_1,client2|
  pending # express the regexp above with the code you wish you had
end
