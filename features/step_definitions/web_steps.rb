When /^(?:|I )go to "([^"]*)"$/ do |url|
  @response = get url
end

Then /^the response should contain "([^"]*)"$/ do |content|
  @response.body.should include(content)
end
