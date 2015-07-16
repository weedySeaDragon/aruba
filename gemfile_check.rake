#!/usr/bin/env rake

require 'fileutils'

desc "Show the Gemfile.lock file to ensure it's not empty"
task :gemfile_check do
  result = "Fail. (reason unknown)"
  if File.exists? "Gemfile.lock"
    puts "\nGemfile.lock is:"
    sh "cat Gemfile.lock"
    result = "\nbundle install was a sucess"
  else
    result = "\nGemfile.lock not found.  Fail."
  end
  puts result
end

desc "delete Gemfile.lock"
task :delgl
  FileUtils.rm "Gemfile.lock" if File.exists? "Gemfile.lock"

task :default => :gemfile_check