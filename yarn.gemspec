# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yarn/version"

Gem::Specification.new do |s|
  s.name        = "yarn"
  s.version     = Yarn::VERSION
  s.authors     = ["Jesper Kjeldgaard"]
  s.email       = ["jkjeldgaard@gmail.com"]
  s.homepage    = "https://github.com/thejspr/yarn"
  s.summary     = %q{Multi-threaded webserver}
  s.description = %q{A multi-threaded web-server written in Ruby 1.9.}

  s.rubyforge_project = "yarn"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
