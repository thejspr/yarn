# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "threaded_server/version"

Gem::Specification.new do |s|
  s.name        = "threaded_server"
  s.version     = ThreadedServer::VERSION
  s.authors     = ["Jesper Kjeldgaard"]
  s.email       = ["jkjeldgaard@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Multi-threaded webserver}
  s.description = %q{A simple multi-threaded web-server with CGI functionality.}

  s.rubyforge_project = "threaded_server"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
