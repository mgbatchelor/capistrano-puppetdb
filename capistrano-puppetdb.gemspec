$:.push File.expand_path("../lib", __FILE__)
require "capistrano/puppetdb/version"

Gem::Specification.new do |s|
  s.name        = 'capistrano-puppetdb'
  s.version     = Capistrano::PuppetDB::VERSION
  s.date        = '2014-12-15'
  s.summary     = 'Use puppetdb to provide hosts for capistrano'
  s.description = 'queries puppetdb for host and role information'
  s.authors     = ['Jeremy Kitchen']
  s.email       = 'jeremy@nationbuilder.com'
  s.files       = ["lib/hola.rb"]
  s.homepage    = 'http://github.com/3dna/capistrano-puppetdb'
  s.license       = 'BSD'
  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano"
  s.add_runtime_dependency "puppetdb-ruby"
end

