require 'aruba/cucumber'

Feature: The Gemfile can handle a variety of platforms and ruby versions.

Given that Aruba will run on many different platforms and with many different ruby versions,
the Gemfile needs to be able to handle a wide variety of combinations of operating systems and
ruby versions. Travis-CI can test configurations on non-windows systems.  Appveyor can test
configurations on windows systems.

  Scenario: Use Travis to test the Gemfile on non-windows systems
    Given The OS is unix
    And a file named "gemfile_check.rake" with:
    """
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
    """
    And a file named ".travis-gemfilecheck.yml" with:
    """
sudo: false
language: ruby
install: script/bootstrap
script: rake gemfile_check

rvm:
- 2.2.2
- 2.1.6
- 2.0.0
- 1.9.3
- 1.8.7
- ruby-head
- jruby-20mode
- jruby-21mode
- jruby-22mode
- jruby
- rbx
    """
    When I use Travis with the ".travis-gemfilecheck.yml" configuration file
    Then the result should not include "fail"
