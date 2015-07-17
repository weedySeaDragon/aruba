require 'spec_helper'
require 'aruba/platform'


# These are not all possible operating systems, architectures, ruby platforms, or ruby engines.
# These are just representative combinations.
# I made some guesses for some of the operating systems and platforms, especially for mac and bsd

def set_ruby_platform(ruby_platform)
  stub_const('RUBY_PLATFORM', ruby_platform)
end


def set_ruby_engine(engine)
  stub_const('RUBY_ENGINE', engine)
end

# FFI::Platform uses OS = case RbConfig::CONFIG['host_os'].downcase
def set_os(host, ruby_platform)
  @rb_config = double('rb_config')
  allow(@rb_config).to receive(:[]).and_return(host)
  stub_const 'RbConfig::CONFIG', @rb_config
  set_ruby_platform(ruby_platform)
end


def use_jruby_engine
  set_ruby_engine('jruby')
  set_ruby_platform('java')
end


def use_rubinius_engine
  set_ruby_engine('rbx')
end


def use_mri_engine
  set_ruby_engine('ruby')
end


def set_as_windows_x64
  set_os('mingw', 'x64-mingw32')
end


def set_as_mac_x64
  set_os('darwin', 'x86_64-darwin-11')
end


def set_as_linux
  set_os('linux', 'i686_linux')
end


def set_as_openbsd
  set_os('openbsd', 'i686_openbsd')
end


def set_as_solaris
  set_os('solaris', 'i686_linux')
end


RSpec.shared_examples 'JRuby installed' do
  it 'RUBY_ENGINE is correct' do
    expect(RUBY_ENGINE).to eq('jruby')
  end
  it 'RUBY_PLATFORM is correct' do
    expect(RUBY_PLATFORM).to eq('java')
  end
end

RSpec.shared_examples 'Rubinius installed' do
  it 'RUBY_ENGINE is correct' do
    expect(RUBY_ENGINE).to eq('rbx')
  end
end

RSpec.shared_examples 'MRI installed' do
  it 'RUBY_ENGINE is correct' do
    expect(RUBY_ENGINE).to eq('ruby')
  end
end

# Aruba operating system, ruby platform and engine tester

RSpec.describe Aruba::Platform do

  before(:context) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        @orig_mock_verify_partial_doubles = mocks.verify_parital_doubles if defined?(mocks.verify_partial_doubles)
        mocks.verify_partial_doubles = true
      end
    end
  end

  after(:context) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = @orig_mock_verify_partial_doubles
      end
    end
  end


  before(:example) do
=begin
    @rb_config = double('rb_config')
    allow(@rb_config).to receive(:[])
    stub_const 'RbConfig::CONFIG', @rb_config, :transfer_nested_constants => true
=end

    @ffip  = class_double("FFI::Platform", :bsd? => false,
                          :windows? => false,
                          :mac? => false,
                          :solaris? => false,
                          :unix? => false).
        as_stubbed_const(:transfer_nested_constants => true)

  end


  describe 'os, ruby_platforms, and ruby_engines' do

    context 'when on linux' do
      before :each do
        allow(@ffip).to receive(:unix?).and_return(true)
      end

      it '#on_unix' do
        expect(Aruba::Platform.on_unix?).to be true
      end
      it '#on_mac' do
        expect(Aruba::Platform.on_mac?).to be false
      end
      it '#on_windows' do
        expect(Aruba::Platform.on_windows?).to be false
      end
      it '#on_bsd' do
        expect(Aruba::Platform.on_bsd?).to be false
      end
      it '#on_solaris' do
        expect(Aruba::Platform.on_solaris?).to be false
      end

      context 'when some mri ruby' do
        before :each do
          use_mri_engine
        end

        it_behaves_like 'MRI installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_linux')
        end
      end

      context 'when some rubinius ruby' do
        before :each do
          use_rubinius_engine
        end

        it_behaves_like 'Rubinius installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_linux')
        end
      end
      context 'when some jruby' do
        before :each do
          use_jruby_engine
        end
        it_behaves_like "JRuby installed"
      end

    end

    context 'when on solaris' do
      before :each do
        allow(@ffip).to receive(:solaris?).and_return(true)
      end

      it '#on_unix' do
        expect(Aruba::Platform.on_unix?).to be false
      end
      it '#on_mac' do
        expect(Aruba::Platform.on_mac?).to be false
      end
      it '#on_windows' do
        expect(Aruba::Platform.on_windows?).to be false
      end
      it '#on_bsd' do
        expect(Aruba::Platform.on_bsd?).to be false
      end
      it '#on_solaris' do
        expect(Aruba::Platform.on_solaris?).to be true
      end

      context 'when some mri ruby' do
        before :each do
          use_mri_engine
        end

        it_behaves_like 'MRI installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_linux')
        end
      end

      context 'when some rubinius ruby' do
        before :each do
          use_rubinius_engine
        end

        it_behaves_like 'Rubinius installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_linux')
        end
      end
      context 'when some jruby' do
        before :each do
          use_jruby_engine
        end

        it_behaves_like "JRuby installed"
      end
    end

    context 'when on bsd' do
      before :each do
        allow(@ffip).to receive(:bsd?).and_return(true)
      end

      it '#on_unix' do
        expect(Aruba::Platform.on_unix?).to be false
      end
      it '#on_mac' do
        expect(Aruba::Platform.on_mac?).to be false
      end
      it '#on_windows' do
        expect(Aruba::Platform.on_windows?).to be false
      end
      it '#on_bsd' do
        expect(Aruba::Platform.on_bsd?).to be true
      end
      it '#on_solaris' do
        expect(Aruba::Platform.on_solaris?).to be false
      end

      context 'when some mri ruby' do
        before :each do
          use_mri_engine
        end

        it_behaves_like 'MRI installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_openbsd')
        end
      end

      context 'when some rubinius ruby' do
        before :each do
          use_rubinius_engine
        end

        it_behaves_like 'Rubinius installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('i686_openbsd')
        end
      end
      context 'when some jruby' do
        before :each do
          use_jruby_engine
        end
        it_behaves_like "JRuby installed"
      end

    end

    context 'when on mac (darwin)' do
      before :each do
        allow(@ffip).to receive(:mac?).and_return(true)
      end

      it '#on_unix' do
        expect(Aruba::Platform.on_unix?).to be false
      end
      it '#on_mac' do
        expect(Aruba::Platform.on_mac?).to be true
      end
      it '#on_windows' do
        expect(Aruba::Platform.on_windows?).to be false
      end
      it '#on_bsd' do
        expect(Aruba::Platform.on_bsd?).to be false
      end
      it '#on_solaris' do
        expect(Aruba::Platform.on_solaris?).to be false
      end

      context 'when some mri ruby' do
        before :each do
          use_mri_engine
        end

        it_behaves_like 'MRI installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('x86_64-darwin-11')
        end
      end

      context 'when some rubinius ruby' do
        before :each do
          use_rubinius_engine
        end

        it_behaves_like 'Rubinius installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('x86_64-darwin-11')
        end
      end

      context 'when some jruby' do
        before :each do
          use_jruby_engine
        end
        it_behaves_like "JRuby installed"
      end

    end

    context 'when on windows' do

      before :each do
        allow(@ffip).to receive(:windows?).and_return(true)
      end

      it '#on_unix' do
        expect(Aruba::Platform.on_unix?).to be false
      end
      it '#on_mac' do
        expect(Aruba::Platform.on_mac?).to be false
      end
      it '#on_windows' do
        expect(Aruba::Platform.on_windows?).to be true
      end
      it '#on_bsd' do
        expect(Aruba::Platform.on_bsd?).to be false
      end
      it '#on_solaris' do
        expect(Aruba::Platform.on_solaris?).to be false
      end

      context 'when some mri ruby' do
        before :each do
          use_mri_engine
        end

        it_behaves_like 'MRI installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('x64-mingw32')
        end

      end

      # TODO Can this even happen?  Does rbx run on windows?
      context 'when some rubinius ruby' do
        before :each do
          use_rubinius_engine
        end

        it_behaves_like 'Rubinius installed'

        it 'RUBY_PLATFORM is correct' do
          expect(RUBY_PLATFORM).to eq('x64-mingw32')
        end
      end

      context 'when some jruby' do
        before :each do
          use_jruby_engine
        end

        it_behaves_like "JRuby installed"

      end
    end

  end

end
