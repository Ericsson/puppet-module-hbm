require 'spec_helper'
describe 'hbm::manage::config' do
  let(:title) { 'testing' }

  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_hbm('testing').only_with(
          {
            'ensure'   => 'present',
            'provider' => 'config',
          },
        )
      end
    end

    context "on #{os} with ensure set to absent" do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_hbm('testing').with_ensure('absent') }
    end

    context "on #{os} with ensure set to invalid" do
      let(:params) { { ensure: 'invalid' } }

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a match for Enum})
      end
    end
  end
end
