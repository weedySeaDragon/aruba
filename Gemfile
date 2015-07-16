source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  gem 'pry', '~> 0.10.1'

  # byebug* gems do not work on JRuby or Rubinius 2015-07-16 = test opportunity
  if RUBY_VERSION >= '2.0' && (RUBY_PLATFORM !=~ /(java)/ &&  RUBY_ENGINE !=~ /(rbx)/ )
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
    gem 'pry-stack_explorer', '~> 0.4.9'
  elsif RUBY_VERSION == '1.9'
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  gem 'pry-doc', '~> 0.8.0'

=begin
from Rails   rails/app_generator_test.rb
https://github.com/rails/rails/blob/master/railties/test/generators/app_generator_test.rb

also @see https://github.com/rails/rails/blob/master/railties/lib/rails/generators/rails/app/templates/Gemfile

  def test_inclusion_of_a_debugger
    run_generator
    if defined?(JRUBY_VERSION) || RUBY_ENGINE == "rbx"
      assert_file "Gemfile" do |content|
        assert_no_match(/byebug/, content)
      end
    else
      assert_gem 'byebug'
    end
  end
=end

=begin
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
  end

  platform :ruby_19 do
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx, :mingw_19, :mingw_20, :mingw_21, :mingw_22  do
    gem 'pry-stack_explorer', '~> 0.4.9'
  end

  gem 'pry-doc', '~> 0.8.0'

=end

end

group :development, :test do
  # Run development tasks
  gem 'rake', '~> 10.4.2'

  # Code Coverage
  gem 'simplecov', '~> 0.10'

  # Test api
  gem 'rspec', '~> 3.3.0'
  gem 'fuubar', '~> 2.0.0'

  if RUBY_VERSION >= '1.9'
    gem 'cucumber', '~> 2.0'

    gem 'rubocop', '~> 0.32.0'

    gem 'cucumber-pro', '~> 0.0'

    # License compliance
    gem 'license_finder', '~> 2.0.4'

    # Upload documentation
    gem 'relish', '~> 0.7.1'
    # Reporting
    gem 'bcat', '~> 0.6.2'
    gem 'kramdown', '~> 1.7.0'

  elsif RUBY_VERSION < '1.9.3'
    gem 'cucumber', '~> 1.3.20'
  end

=begin
      platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    # Reporting
    gem 'bcat', '~> 0.6.2'
    gem 'kramdown', '~> 1.7.0'
  end

  # Code Coverage
  gem 'simplecov', '~> 0.10'

  # Test api
  gem 'rspec', '~> 3.3.0'
  gem 'fuubar', '~> 2.0.0'

  # using platform for this make bundler complain about the same gem given
  # twice
  if RUBY_VERSION < '1.9.3'
    gem 'cucumber', '~> 1.3.20'
  else
    gem 'cucumber', '~> 2.0'
  end

  # Make aruba compliant to ruby community guide
  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx, :mingw_19, :mingw_20, :mingw_21, :mingw_22  do
    gem 'rubocop', '~> 0.32.0'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx, :mingw_19, :mingw_20, :mingw_21, :mingw_22  do
    gem 'cucumber-pro', '~> 0.0'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx, :mingw_19, :mingw_20, :mingw_21, :mingw_22  do
    # License compliance
    gem 'license_finder', '~> 2.0.4'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx, :mingw_19, :mingw_20, :mingw_21, :mingw_22  do
    # Upload documentation
    gem 'relish', '~> 0.7.1'
  end
=end
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end
