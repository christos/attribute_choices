Gem::Specification.new do |s|
  s.name = "attribute_choices"
  s.version = "1.0.2"

  s.authors = ["Christos Zisopoulos"]
  s.date = "2011-05-12"
  s.email = "christos@me.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = %w(License.md README.md) + Dir.glob("lib/**/*")
  s.homepage = "http://github.com/christos/attribute_choices"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.summary = s.description = "Extends ActiveRecord attributes with a `:choices` pseudo-type that provides convenient methods for mapping each choice to its human readable form."
  
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"

  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
end