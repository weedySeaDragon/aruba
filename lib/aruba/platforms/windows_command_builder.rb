require 'aruba/platforms/process_command_builder'

module Aruba
  module Platforms
    # WARNING:
    # All methods found here are not considered part of the public API of aruba.
    #
    # Those methods can be changed at any time in the feature or removed without
    # any further notice.
    #

    # Build the command for a Process, specific to the Windows platform
    #
    # ChildProcess requires the command array (of Strings) to be slightly different for
    # a command that is to run in a separate process in Windows. This is what needs to be
    # passed to ChildProcess:
    #   process = ChildProcess.build("cmd.exe", "/c", "echo 'Hello World'")
    #
    class WindowsCommandBuilder < ProcessCommandBuilder
      # note that ChildProcess expects Windows commands to have 'cmd.exe /c ' at the start
      # in order to run the command in a separated process
      #
      # @return [Array] of Strings suitable for passing to ChildProcess.build(*)
      def build_child_process_args(command_with_path, *args)
        args.reject!(&:nil?)
        args.empty? ? %w[cmd.exe /c] + [command_with_path] : (%w[cmd.exe /c] + [command_with_path] + args).flatten
      end

      # The default implementation uses Shellwords, which doesn't parse all strings correctly for Windows.
      # Ex: given the commandline 'echo "hello world"'
      # Shellwords.split(commandline)....   will remove the quotes around "hello world" and then
      # when Childprocess tries to run ChildProcess(["cmd.exe", "/c", "echo", "hello","world"]) it will fail
      # with the error message " echo hello" is not a program.....
      # Even using Shellwords.split()Shellwords.shellescape(commandline)) doesn't work. Here's the doc
      # from Shellwords showing that it deliberately removes the quotes around a string ("two words"):
      #   argv = 'here are "two words"'.shellsplit
      #   argv #=> ["here", "are", "two words"]
      #
      #  So this fails: 'echo "hello world"'  Shellwords.split('echo "hello world"')  ==> ["echo", "hello", "world"]
      #  but this works: "echo 'hello world'" Shellwords.split("echo 'hello world'") ==> ["echo", "hello world"]

      def command_args(whole_commandline)
        command_parts = split_command(whole_commandline)
        return command_parts[1..-1] if command_parts.size > 1
      end

      # based on Shellwords.split
      # this method may not be needed; it's here to try to figure out if we can get double-quotes and
      # single-quotes working with Windows
      # rubocop:disable Metrics/CyclomaticComplexity
      def split_command(line)
        words = []
        field = ''
        # rubocop:disable Style/MultilineBlockLayout
        line.scan(/\G\s*(?>([^\s\\\'\"]+)|'([^\']*)'|"((?:[^\"\\]|\\.)*)"|(\\.?)|(\S))(\s|\z)?/m) do
           |word, sq, dq, esc, garbage, sep|
          # rubocop:endable Style/MultilineBlockLayout
          raise ArgumentError, "Unmatched double quote: #{line.inspect}" if garbage
          field << (word || sq || (dq || esc).gsub(/\\(.)/, '\\1'))
          field = "\"#{dq}\"" if dq
          field = "'#{sq}'" if sq
          if sep
            words << field
            field = ''
          end
        end
        words
      end
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
