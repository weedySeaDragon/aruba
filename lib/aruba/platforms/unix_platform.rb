require 'aruba/platforms/abstract_os_platform'
require 'pathname'
require 'ffi'

require 'aruba/platforms/simple_table'

module Aruba
  # This abstracts Unix specific things
  module Platforms
    # WARNING:
    # All methods found here are not considered part of the public API of aruba.
    #
    # Those methods can be changed at any time in the feature or removed without
    # any further notice.
    #
    # This includes all methods for the UNIX platform
    class UnixPlatform < AbstractOSPlatform
      attr_reader :command_builder

      def initialize
        @command_builder = UnixCommandBuilder.new
      end

      def self.match?
        FFI::Platform.unix
      end

      # Resolve path for command using the PATH-environment variable
      #
      # Mostly taken from here: https://github.com/djberg96/ptools
      #
      # @param [#to_s] program
      #   The name of the program which should be resolved
      #
      # @param [String] path
      #   The PATH, a string concatenated with ":", e.g. /usr/bin/:/bin on a
      #   UNIX-system
      #
      # rubocop:disable Metrics/CyclomaticComplexity
      def which(program, path = ENV['PATH'])
        program = program.to_s

        raise ArgumentError, "ENV['PATH'] cannot be empty" if path.nil? || path.empty?

        # Bail out early if an absolute path is provided or the command path is relative
        # Examples: /usr/bin/command or bin/command.sh
        if Aruba.platform.absolute_path?(program) || Aruba.platform.relative_command?(program)
          found = Dir[program].first

          return File.expand_path(found) if found && Aruba.platform.executable_file?(found)
          return nil
        end

        # Iterate over each path glob the dir + program.
        path.split(File::PATH_SEPARATOR).each do |dir|
          dir = Aruba.platform.expand_path(dir, Dir.getwd)

          next unless Aruba.platform.exist?(dir) # In case of bogus second argument
          file = File.join(dir, program)

          found = Dir[file].first

          # Convert all forward slashes to backslashes if supported
          if found && Aruba.platform.executable_file?(found)
            return found
          end
        end
        nil
      end
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
