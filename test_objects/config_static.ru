require 'rubygems'
require 'rack'

run Proc.new { |env|
	app = Rack::Builder.new {
		use Rack::CommonLogger
		use Rack::ShowExceptions
		run Rack::Directory.new(Dir.pwd)
	}
	app.call(env)
}
