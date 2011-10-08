$:.unshift Dir.pwd
require File.expand_path("./lib/retry_upto")

Gem::Specification.new do |s|
  s.name        = "retry_upto"
  s.version     = "1.1"
  s.authors     = ["Raul Murciano", "Glenn Gillen", "Pedro Belo", "Jaime Iniesta", "Lleïr Borras", "Aitor García Rey"]
  s.email       = ["raul@murciano.net"]
  s.homepage    = "http://github.com/raul/retry_upto"
  s.summary     = "retry with steroids"
  s.description = "adds some useful options to retry code blocks"


  s.files             = Dir["{lib,test}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path      = 'lib'

  s.add_development_dependency 'minitest', '>2.0'
  s.add_development_dependency 'mocha', '>=0.10.0'
  s.add_development_dependency 'rake', '>=0.9.2'

  s.rubyforge_project         = "retry_upto"
  s.platform    = Gem::Platform::RUBY
end