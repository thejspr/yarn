Given /^I have a rack application "([^"]*)"$/ do |app|
   testfile_exists?(app).should be_true 
end

Given /^the rack application "([^"]*)" is running$/ do |app|
  system("rackup -s Yarn test_objects/#{app} &")
  sleep 3
  res = `ps aux | grep [r]uby | grep [r]ackup`
  @rack_server = res.split[1].to_i
end
