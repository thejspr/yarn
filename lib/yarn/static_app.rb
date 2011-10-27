require 'rubygems'
require 'rack'

module Yarn
	class StaticApp

		def initialize
			@app = Rack::Builder.new {
				use Rack::CommonLogger
				use Rack::ShowExceptions
				run Rack::File.new(Dir.pwd)
			}
		end

		def call(env)
			@app.call(env)
		end

	end
end
