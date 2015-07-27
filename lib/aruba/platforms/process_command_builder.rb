require 'shellwords'

module Aruba
  module Platforms
    # WARNING:
    # All methods found here are not considered part of the public API of aruba.
    #
    # Those methods can be changed at any time in the feature or removed without
    # any further notice.
    #

    # Build the command for a ChildProcess
    #
    class ProcessCommandBuilder
      def base_command(whole_commandline)
        Shellwords.split(whole_commandline).first
      end

      def command_args(whole_commandline)
        return Shellwords.split(whole_commandline)[1..-1] if Shellwords.split(whole_commandline).size > 1
      end

      # return the arguments (Array) suitable for passing to ChildProcess.build(). Some platforms need to alter this
      #
      # @return [Array] of Strings suitable for passing to ChildProcess.build()
      def build_child_process_args(command_with_path, *args)
        ([command_with_path] + args).flatten
      end

    end
  end
end
