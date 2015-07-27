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
        args.reject! {|x| x.nil?}
        args.empty? ? %w[cmd.exe /c] + [command_with_path] : (%w[cmd.exe /c] + [command_with_path] + args).flatten
      end
    end
  end
end
