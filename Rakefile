# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = ""
  # t.cucumber_opts = "--format Cucumber::Pro --out cucumber-pro.log" if ENV['CUCUMBER_PRO_TOKEN']
  t.cucumber_opts << "--format pretty"
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.cucumber_opts = "-p wip"
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color', '--format documentation']
end
=begin
if RUBY_VERSION < '1.9'
  begin
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new
  rescue LoadError
    desc 'Stub task to make rake happy'
    task(:rubocop) {}
  end
else
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
=end

desc "Run tests, both RSpec and Cucumber"
task :test => [ :rubocop, :spec, :cucumber, :cucumber_wip]

desc 'check to see how versions are reported with rubys other than MRI'
task :versions_check
  puts "\n Checking Ruby version =#{RUBY_VERSION}=\n\n"


#task :default => :test
task :default => :versions_check
