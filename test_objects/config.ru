require 'rubygems'
require 'rack'

# The root of our app
@root = File.expand_path(File.dirname(__FILE__))

run Proc.new { |env|
  # Extract the requested path from the request
  path = Rack::Utils.unescape(env['PATH_INFO'])
  index_file = @root + "#{path}/index.html"

  if File.exists?(index_file)
    # Return the index
    [200, {'Content-Type' => get_mime_type(index_file)}, read_file(index_file)]
  elsif File.exists?(path) && !File.directory?(path)
    # Return the file
    [200, {'Content-Type' => get_mime_type(path)}, read_file(path)]
  else
    # Return a directory listing
    Rack::Directory.new(@root).call(env)
  end
}

def read_file(path)
  file_contents = []
  File.open(path, "r") do |file|
    while (line = file.gets) do
      file_contents << line
    end
  end
  file_contents
end


def get_mime_type(path)
  return false unless path.include? '.'
  filetype = path.split('.').last

  return case
    when ["html", "htm"].include?(filetype)
      "text/html"
    when "txt" == filetype 
      "text/plain"
    when "css" == filetype
      "text/css"
    when "js" == filetype
      "text/javascript"
    when ["png", "jpg", "jpeg", "gif", "tiff"].include?(filetype)
      "image/#{filetype}"
    when ["zip","pdf","postscript","x-tar","x-dvi"].include?(filetype)
      "application/#{filetype}"
    else false
  end
end
