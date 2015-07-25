require 'aruba/platforms/unix_platform'
require 'ffi'
require 'aruba/platforms/windows_environment_vars'

module Aruba
  # This abstracts OS-specific things
  module Platforms
    # WARNING:
    # All methods found here are not considered part of the public API of aruba.
    #
    # Those methods can be changed at any time in the feature or removed without
    # any further notice.
    #
    # This includes all methods for the Windows platform
    class WindowsPlatform < UnixPlatform
      def self.match?
        FFI::Platform.windows?
      end

      def environment_variables
        WindowsEnvironmentVars.new
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
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def which(program, path = ENV['PATH'])
        program = program.to_s

        path_exts = ENV['PATHEXT'] ? ('.{' + ENV['PATHEXT'].tr(';', ',').tr('.', '') + '}').downcase : '.{exe,com,bat}'

        raise ArgumentError, "ENV['PATH'] cannot be empty" if path.nil? || path.empty?

        # Bail out early if an absolute path is provided or the command path is relative
        # Examples: /usr/bin/command or bin/command.sh
        if Aruba.platform.absolute_path?(program) || Aruba.platform.relative_command?(program)
          program += path_exts if File.extname(program).empty?

          found = Dir[program].first

          return File.expand_path(found) if found && Aruba.platform.executable_file?(found)
          return nil
        end

        # Iterate over each path glob the dir + program.
        path.split(File::PATH_SEPARATOR).each do |dir|
          dir = Aruba.platform.expand_path(dir, Dir.getwd)

          next unless Aruba.platform.exist?(dir) # In case of bogus second argument
          file = File.join(dir, program)

          # Dir[] doesn't handle backslashes properly, so convert them. Also, if
          # the program name doesn't have an extension, try them all.

          file = file.tr("\\", "/")
          file += path_exts if File.extname(program).empty?


          found = Dir[file].first

          # Convert all forward slashes to backslashes if supported
          if found && Aruba.platform.executable_file?(found)
            found.tr!(File::SEPARATOR, File::ALT_SEPARATOR)
            command = fixup_cmd(found)
            return command
          end
        end

        nil
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity


      def fixup_cmd(command)
        command = %w[cmd.exe /c] + [command]
      end

    end
  end
end
