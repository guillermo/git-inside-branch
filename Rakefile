require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'rake/testtask'


Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end


task :default => :test
