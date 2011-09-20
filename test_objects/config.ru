require 'rubygems'
require 'rack'

# This is the root of our app
@root = File.expand_path(File.dirname(__FILE__))

run Proc.new { |env|
  # Extract the requested path from the request
  path = Rack::Utils.unescape(env['PATH_INFO'])
  index_file = @root + "#{path}/index.html"

  if File.exists?(index_file)
    # Return the index
    file_contents = []
    File.open(index_file, "r") do |file|
      while (line = file.gets) do
        file_contents << line
      end
    end
    
    [200, {'Content-Type' => 'text/html'}, file_contents]
  else
    Rack::Directory.new(@root).call(env)
  end
}
