Given /^a client "([^"]*)"$/ do |client|
  @clients ||= {}
  @clients[client] = nil
end

When /^client "([^"]*)" makes a "([^"]*)" seconds? request$/ do |client,speed|
  @responses ||= {}
  filename = "test_objects/#{speed}.rb"
  unless File.exists? filename
    File.open(filename, 'w') { |f| f.write "sleep(#{speed}); p 'complete'\n" }
  end
  @clients[client] = Thread.new do 
    result = get filename
    $stdout.puts result
    @responses[client] = result
  end
end

Then /^client "([^"]*)" receives a response before client "([^"]*)"$/ do |c1,c2|
  response_listener = Thread.new do
    loop do
      if @responses[c1] == "complete" && @responses[c2].empty?
        return true
      elsif @responses[c2] == "complete"
        return false
      end
    end
  end
  # response_listener.run
  @clients.each { |t| t.join }
end
