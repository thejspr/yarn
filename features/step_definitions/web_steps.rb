When /^(?:|I )go to "([^"]*)"$/ do |url|
  @response = get url
end

Then /^the response should contain "([^"]*)"$/ do |content|
  @response.body.should include(content)
end

Then /^the response should be "([^"]*)"$/ do |content|
  @response.body.gsub(/\n?/,"").should == content
end

When /^I post "([^"]*)" as "([^"]*)" to "([^"]*)"$/ do |key, value, url|
  @response = post(url, { key.to_sym => value })
end
