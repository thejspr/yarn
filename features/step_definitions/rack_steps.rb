Given /^I have a rack application "([^"]*)"$/ do |app|
   testfile_exists?(app).should be_true 
end
