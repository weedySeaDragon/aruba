source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  gem 'pry', '~> 0.10.1'

  # byebug* gems do not work on JRuby or Rubinius 2015-07-16
  # Note that for JRuby, RUBY_PLATFORM = java  and RUBY_ENGINE = jruby
  # Note that for Rubinius, RUBY_PLATFORM = <a unix platform> and RUBY_ENGINE = rbx

  if RUBY_VERSION >= '2.0' && !defined?(JRUBY_VERSION)
    install_if -> { !(RUBY_ENGINE =~ /rbx/) && !(RUBY_ENGINE =~ /jruby/) } do
      gem 'byebug', '~> 4.0.5'
      gem 'pry-byebug', '~> 3.1.0'
      gem 'pry-stack_explorer', '~> 0.4.9'
    end
  elsif RUBY_VERSION == '1.9'
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  gem 'pry-doc', '~> 0.8.0', :platforms => [:mri, :rbx, :jruby]  # pry-doc does not work for windows as of 2015-07-16
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
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end
