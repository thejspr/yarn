require 'rubygems'
require 'rack'

run Proc.new { |env|
  [200, {'Content-Type' => "text/plain"}, ["Rack works"]]
}
