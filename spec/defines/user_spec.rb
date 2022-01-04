require 'spec_helper'
describe 'hbm::manage::user' do
  let(:title) { 'testing' }

  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_hbm('testing').only_with(
          {
            'ensure'     => 'present',
            'provider'   => 'user',
            'members'    => [],
          },
        )
      end
    end

    context "on #{os} with ensure set to absent" do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_hbm('testing').with_ensure('absent') }
    end

    context "on #{os} with members set to [ TEST ]" do
      let(:params) { { members: [ 'TEST' ] } }

      it { is_expected.to contain_hbm('testing').with_members(['TEST']) }
    end

    context "on #{os} with ensure set to invalid" do
      let(:params) { { ensure: 'invalid' } }

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{hbm::manage::user::testing::ensure is invalid and does not match the regex.})
      end
    end

    ['string', { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with members set to invalid #{param} (as #{param.class})" do
        let(:params) { { members: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{is not an Array})
        end
      end
    end
  end
end
