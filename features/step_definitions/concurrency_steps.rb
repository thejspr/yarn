Given /^a client "([^"]*)"$/ do |client|
  @clients ||= {}
  @clients[client] = nil
end

When /^client "([^"]*)" makes a "([^"]*)" request$/ do |client,speed|
  @clients[client] = Thread.new { @response = get "/#{speed}.rb" }
end

Then /^client "([^"]*)" receives a response before client "([^"]*)"$/ do |c1,c2|
  loop do
    if @clients[c1].response == "complete"
      return true
    elsif @clients[c2].response == "complete"
      return false
    end
  end
end
