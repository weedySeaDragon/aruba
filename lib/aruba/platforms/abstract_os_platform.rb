require 'rbconfig'
require 'pathname'

require 'aruba/platforms/simple_table'

module Aruba
  # This abstracts OS-specific things
  module Platforms
    # WARNING:
    # All methods found here are not considered part of the public API of aruba.
    #
    # Those methods can be changed at any time in the feature or removed without
    # any further notice.
    #
    class AbstractOSPlatform
      attr_reader :command_builder

      def initialize
        @command_builder = UnixCommandBuilder.new # this is the default command builder
      end

      # Each child class MUST implement this, providing a boolean that will evaluate to true when
      # aruba is running on that particular OS platform.
      def self.match?
        raise NotImplementedError, "__method__ must be implemented by a subclass of AbstractOSPlatform."
      end

      def child_process_args(command_line)
        cmd = command_builder.base_command(command_line)
        command_with_path = which(cmd)
        fail LaunchError, %(Command "#{cmd}" not found in PATH-variable "#{environment_variables['PATH']}".) unless command_with_path

        args = command_builder.command_args(command_line)
        args.reject!(&:nil?) unless args.nil?  # remove any nil (empty) args

        command_builder.build_child_process_args(which(cmd), args)
      end

      def environment_variables
        Environment.new
      end

      def detect_ruby(cmd)
        if cmd =~ /^ruby\s/
          cmd.gsub(/^ruby\s/, " #{current_ruby} ")
        else
          cmd
        end
      end

      def deprecated(msg)
        warn(format('%s. Called by %s', msg, caller[1]))
      end

      def current_ruby
        ::File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
      end

      # @deprecated
      # Add newline at the end
      def ensure_newline(str)
        deprecated('The use of "#ensure_newline" is deprecated. It will be removed soon')
        str.chomp << "\n"
      end

      def require_matching_files(pattern, base)
        if RUBY_VERSION < '1.9.3'
          ::Dir.glob(::File.expand_path(pattern, base)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
        else
          ::Dir.glob(::File.expand_path(pattern, base)).each { |f| require_relative f }
        end
      end

      # Create directory and subdirectories
      def mkdir(dir_name)
        dir_name = ::File.expand_path(dir_name)

        ::FileUtils.mkdir_p(dir_name) unless ::File.directory?(dir_name)
      end

      # Remove file, directory + sub-directories
      def rm(paths, options = {})
        paths = Array(paths).map { |p| ::File.expand_path(p) }

        FileUtils.rm_r(paths, options)
      end

      # Get current working directory
      def getwd
        Dir.getwd
      end

      # Change to directory
      def chdir(dir_name, &block)
        dir_name = ::File.expand_path(dir_name.to_s)

        begin
          if RUBY_VERSION <= '1.9.3'
            old_env = ENV.to_hash
          else
            old_env = ENV.to_h
          end

          ENV['OLDPWD'] = getwd
          ENV['PWD'] = dir_name
          ::Dir.chdir(dir_name, &block)
        ensure
          ENV.clear
          ENV.update old_env
        end
      end

      # Touch file, directory
      def touch(args, options)
        FileUtils.touch(args, options)
      end

      # Copy file/directory
      def cp(args, options)
        FileUtils.cp_r(args, options)
      end

      # Change mode of file/directory
      def chmod(mode, args, options)
        FileUtils.chmod_R(mode, args, options)
      end

      # Exists and is file
      def file?(f)
        File.file? f
      end

      # Exists and is directory
      def directory?(f)
        File.directory? f
      end

      # Path Exists
      def exist?(f)
        File.exist? f
      end

      # Path is executable
      def executable_file?(f)
        File.file?(f) && File.executable?(f)
      end

      # Expand path
      def expand_path(path, base)
        File.expand_path(path, base)
      end

      def absolute_path?(path)
        Pathname.new(path).absolute?
      end

      # Check if command is relative
      #
      # @return [TrueClass, FalseClass]
      #   true
      #     * bin/command.sh
      #
      #   false
      #     * /bin/command.sh
      #     * command.sh
      def relative_command?(path)
        p = Pathname.new(path)
        p.relative? && p.basename != p
      end

      # Write to file
      def write_file(path, content)
        if RUBY_VERSION < '1.9.3'
          File.open(path, 'wb') do |f|
            f.print content
          end
        else
          File.write(path, content)
        end
      end

      # Unescape string
      #
      # @param [String] string
      #   The string which should be unescaped, e.g. the output of a command
      #
      # @return
      #   The string stripped from escape sequences
      def unescape(string, keep_ansi = true)
        string = string.gsub('\n', "\n").gsub('\"', '"').gsub('\e', "\e")
        string = string.gsub(/\e\[\d+(?>(;\d+)*)m/, '') unless keep_ansi
        string
      end

      # Transform hash to a string table which can be output on stderr/stdout
      def simple_table(hash)
        SimpleTable.new(hash).to_s
      end

      # Find the program on the path and return the entire path+program file name
      #
      # Each subclass must implement this as appropriate on that platform
      def which(program, path = ENV['PATH'])
        raise NotImplementedError, "__method__ must be implemented by a subclass of AbstractOSPlatform"
      end
    end
  end
end
