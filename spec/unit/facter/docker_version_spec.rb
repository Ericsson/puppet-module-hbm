require 'spec_helper'

describe 'docker_version', type: :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'with docker version 1.12.0' do
    it do
      Facter::Util::Resolution.expects(:which).with('docker').returns(true)
      Facter::Core::Execution.expects(:execute).with('docker version -f {{.Client.Version}} 2> /dev/null').returns('1.12.0')
      expect(Facter.fact(:docker_version).value).to eq('1.12.0')
    end
  end

  context 'with docker version 20.10.12' do
    it do
      Facter::Util::Resolution.expects(:which).with('docker').returns(true)
      Facter::Core::Execution.expects(:execute).with('docker version -f {{.Client.Version}} 2> /dev/null').returns('20.10.12')
      expect(Facter.fact(:docker_version).value).to eq('20.10.12')
    end
  end

  context 'with invalid docker version' do
    it do
      Facter::Util::Resolution.expects(:which).with('docker').returns(true)
      Facter::Core::Execution.expects(:execute).with('docker version -f {{.Client.Version}} 2> /dev/null').returns('docker %%VSN%%')
      expect(Facter.fact(:docker_version).value).to be_nil
    end
  end

  context 'with docker not in path' do
    it do
      Facter::Util::Resolution.expects(:which).with('docker').returns(false)
      expect(Facter.fact(:docker_version).value).to be_nil
    end
  end
end
