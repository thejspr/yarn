Given /^a client "([^"]*)"$/ do |client|
  @clients = {}
end

When /^client "([^"]*)" makes a "([^"]*)" seconds? request$/ do |client,speed|
  @responses = {}
  filename = "test_objects/#{speed}.rb"
  File.delete filename if File.exists? filename
  File.open(filename, 'w') { |f| f.write "sleep(#{speed}); p 'complete: #{speed}s'\n" }

  @clients[client] = Thread.new do 
    result = get "/#{speed}.rb"
    @responses[client] = result.body
  end
end

Then /^client "([^"]*)" receives a response before client "([^"]*)"$/ do |c1,c2|
  @success = false
  response_listener = Thread.new do
    while !@success do
      if @responses[c1] =~ /complete/ && !@responses[c2]
        @success = true
        break
      elsif @responses[c2] =~ /complete/
        @success = false
        break
      end
    end
  end

  response_listener.join

  @success.should be_true
end
