# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "attribute_choices/version"

Gem::Specification.new do |s|
  s.name    = "attribute_choices"
  s.version = AttributeChoices::VERSION

  s.authors = ["Christos Zisopoulos"]
  s.date    = "2011-05-12"
  s.email   = "christos@me.com"


  s.rubyforge_project = "attribute_choices"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.homepage = "http://github.com/christos/attribute_choices"

  s.rdoc_options  = ["--main", "README.md"]
  s.extra_rdoc_files = ["README.md"]
  s.summary       = s.description = "Extends ActiveRecord attributes with a `:choices` pseudo-type that provides convenient methods for mapping each choice to its human readable form."

  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"

  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
end