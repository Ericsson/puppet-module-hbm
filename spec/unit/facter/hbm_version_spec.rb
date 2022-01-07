require 'spec_helper'

describe 'hbm_version', type: :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'with hbm version 1.12.0' do
    it do
      Facter::Util::Resolution.expects(:which).with('hbm').returns(true)
      Facter::Core::Execution.expects(:execute).with("hbm version | grep -E '^HBM|^Version' | awk '{ print $2 }' 2> /dev/null").returns('1.12.0')
      expect(Facter.fact(:hbm_version).value).to eq('1.12.0')
    end
  end

  context 'with hbm version 20.10.12' do
    it do
      Facter::Util::Resolution.expects(:which).with('hbm').returns(true)
      Facter::Core::Execution.expects(:execute).with("hbm version | grep -E '^HBM|^Version' | awk '{ print $2 }' 2> /dev/null").returns('20.10.12')
      expect(Facter.fact(:hbm_version).value).to eq('20.10.12')
    end
  end

  context 'with invalid hbm version' do
    it do
      Facter::Util::Resolution.expects(:which).with('hbm').returns(true)
      Facter::Core::Execution.expects(:execute).with("hbm version | grep -E '^HBM|^Version' | awk '{ print $2 }' 2> /dev/null").returns('docker %%VSN%%')
      expect(Facter.fact(:hbm_version).value).to be_nil
    end
  end

  context 'with hbm not in path' do
    it do
      Facter::Util::Resolution.expects(:which).with('hbm').returns(false)
      expect(Facter.fact(:hbm_version).value).to be_nil
    end
  end
end
