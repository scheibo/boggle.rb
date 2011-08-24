# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "boggle/version"

Gem::Specification.new do |s|
  s.name        = "boggle"
  s.version     = Boggle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kirk Scheibelhut"]
  s.email       = ["kjs@scheibo.com"]
  s.homepage    = "https://github.com/scheibo/boggle"
  s.summary     = "Boggle CLI app which helps improve your game"
  s.description = s.summary

  s.rubyforge_project = "boggle"

  s.add_dependency "trollop"
  s.add_dependency "algorithms"

  s.add_development_dependency "rake"
  s.add_development_dependency "bundler", "~> 1.0.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.default_executable = 'boggle'
  s.require_paths = ["lib"]
end
