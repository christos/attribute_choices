Gem::Specification.new do |s|
  s.name = "attribute_choices"
  s.version = "1.0.1"

  s.authors = ["Christos Zisopoulos"]
  s.date = "2011-05-12"
  s.email = "christos@me.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = %w(License.md README.md) + Dir.glob("lib/**/*")
  s.homepage = "http://github.com/christos/attribute_choices"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.summary = s.description = "AttributeChoices is a plugin that simplifies the common pattern of mapping a set of discreet values for an ActiveRecord model attribute, to a set of display values for human consumption."
  
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"

  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
end