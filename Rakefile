# frozen_string_literal: true

require 'date'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'bundler/gem_tasks'

RuboCop::RakeTask.new(:lint)

desc 'Run test_unit based test'
Rake::TestTask.new do |t|
  # To run test for only one file (or file path pattern)
  #  $ bundle exec rake test TEST=test/test_specified_path.rb
  t.libs << 'test'
  t.test_files = Dir['test/**/*_test.rb']
  t.verbose = true
end

task default: :test
