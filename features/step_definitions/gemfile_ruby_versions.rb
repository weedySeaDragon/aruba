

# parse a Gemfile.lock file (found at gemfilelock_path) and return a hash of gems, each gem with it's version string
def parse_gemfile_lock(gemfilelock_fpath='./Gemfile.lock')
  gems = []
  File.open(gemfilelock_fpath, "r") do |gfl|

  end
  gems
end




Given(/^The OS is (.*)$/) do |os_name|
  @os = os_name
end

And(/^The ruby distribution is (.*)$/) do |ruby_distro|
  @ruby_distro = ruby_distro
end

And(/^The ruby version is (.*)$/) do |ruby_version|
  @ruby_version = ruby_version
end

When(/^Bundle install has been run successfully$/) do
  pending #
end

And(/^the Gemfile\.lock has been parsed$/) do
  @gemfilelock_gems = parse_gemfile_lock()
end

Then(/^the parsed results have (.*)$/) do |gems|
  pending # ^@gemfilelock_gems.includes? gems
end

And(/^the parsed results should not contain (.*)$/) do |doesnt_have_gems|
  pending # ^!@gemfilelock_gems.includes? doesnt_have_gems
end
