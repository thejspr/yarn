require 'uri'
require 'cgi'

Given /^(?:|I )am on (.+)$/ do |url|
  visit "http://#{@server.host}:#{@server.port}/#{url}"
end

When /^(?:|I )go to (.+)$/ do |url|
  get url
end

When /^(?:|I )visit (.+)$/ do |url|
  visit "http://#{@server.host}:#{@server.port}/#{url}"
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

Then /^the page should contain "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^the page should contain \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

Then /^the page should not contain "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^the page should not contain \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end
 
Then /^(?:|I )should be on (.+)$/ do |url|
  url = "http://#{@server.host}:#{@server.port}#{url}"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == url
  else
    assert_equal url, current_path
  end
end

Then /^show me the page$/ do
  save_and_open_page
end
