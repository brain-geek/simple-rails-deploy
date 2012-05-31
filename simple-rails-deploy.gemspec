# -*- encoding: utf-8 -*-

require 'rake'
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "simple-rails-deploy"
  s.version = '0.0.1'

  s.authors = ["Alex Rozumey"]
  s.date = "2012-02-09"
  s.description = "It simplifies rails deployment process a lot"
  s.email = "brain-geek@yandex.ua"

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.homepage = "http://github.com/brain-geek/simple-rails-deploy"
  s.licenses = ["MIT"]
  s.rubygems_version = "1.8.15"
  s.summary = ""

  s.add_dependency(%q<rails>, '>=3.0.0')
  s.add_dependency(%q<capistrano>)
  s.add_dependency(%q<rvm-capistrano>)
  s.add_dependency(%q<capistrano_colors>)
end