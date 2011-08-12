ENV["RAILS_ENV"] = "test"

require 'rubygems'

require 'i18n'
require 'attribute_choices'

require 'test/unit'

require 'active_support/test_case'
require 'active_record/fixtures'

#raise Dir[File.dirname(__FILE__) + "/en.yml"].inspect

I18n.load_path += Dir[File.dirname(__FILE__) + "/en.yml"]
I18n.default_locale = :en

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3mem'])

ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/schema.rb")

