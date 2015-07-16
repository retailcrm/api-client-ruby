# encoding: utf-8

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/spec_*.rb']
  t.verbose = true
end

desc 'Run tests'
task :default => :test
