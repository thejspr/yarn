Given /^a parser$/ do
  @parser = Yarn::Parser.new
end

When /^I feed the request to the parser$/ do
  @result = @parser.run(@request)
end

Given /^a HTTP request "([^"]*)"$/ do |req|
  @request = req.gsub('\\r\\n') { "\r\n" }
end

Then /^the result "([^"]*)" should be "([^"]*)"$/ do |key, value|
  @result[key.to_sym].to_s.should == value
end

Then /^the result "([^"]*)" should include "([^"]*)" with "([^"]*)"$/ do |outer_key, inner_key, value|
  @result[outer_key.to_sym][inner_key.to_sym].to_s.should == value
end

Then /^the result "([^"]*)" should have "([^"]*)" with "([^"]*)"$/ do |outer_key, inner_key, value|
  @result[outer_key.to_sym][inner_key].to_s.should == value
end
