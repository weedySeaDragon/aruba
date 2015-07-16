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

desc "Run tests, both RSpec and Cucumber"
task :test => [ :rubocop, :spec, :cucumber, :cucumber_wip]

#task :default => :test

#------------------------------


task :ensure_bundler_version do
  min_version_str = '1.9.5'
  min_version = Gem::Version.new(min_version_str)
  bundler_version = Gem::Version.new(Bundler::VERSION)

  raise "Bundler #{min_version-str} is a development dependency to build ammeter. Please upgrade bundler." unless bundler_version >= min_version
end

task :ensure_bundler_no_coc_prompt do
  sh "bundle config gem.coc false"
  sh "bundle config gem.mit false"
  sh "bundle config gem.test rspec"
end

task :ensure_bundler_ok => [:ensure_bundler_version, :ensure_bundler_no_coc_prompt]


task :show_ruby_info do
  puts "\n RUBY_VERSION =#{RUBY_VERSION}="
  puts "\n RUBY_PLATFORM =#{RUBY_PLATFORM}="
end


task :show_rbconfig => [ :ensure_bundler_ok, :show_ruby_info]


task :default => :show_rbconfig