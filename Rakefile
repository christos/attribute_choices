require 'rake'
require 'rake/testtask'
require "bundler/gem_tasks"

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the attribute_choices plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

