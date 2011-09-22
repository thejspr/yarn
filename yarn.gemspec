# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yarn/version"

Gem::Specification.new do |s|
  s.name        = "yarn"
  s.version     = Yarn::VERSION
  s.authors     = ["Jesper Kjeldgaard"]
  s.email       = ["jkjeldgaard@gmail.com"]
  s.homepage    = "https://github.com/thejspr/yarn"
  s.summary     = %q{Multi-threaded webserver for static and dynamic (*.rb) files as well as rack applications.}
  s.description = %q{A multi-threaded web-server written in Ruby 1.9.}

  s.rubyforge_project = "yarn"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,test_objects}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('parslet', '>= 1.2')
  s.add_dependency('trollop', '>= 1.16.2')
  s.add_dependency('rack', '>= 1.3.3')
  # s.add_dependency('celluloid', '>= 0.2.1')

  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'faraday'
  s.add_development_dependency 'nokogiri'
  # s.add_development_dependency 'capybara'
  # s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakefs'
  s.add_development_dependency 'simplecov'
end
