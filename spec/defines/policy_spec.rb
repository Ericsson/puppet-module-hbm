require 'spec_helper'
describe 'hbm::manage::policy' do
  let(:title) { 'testing' }

  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_hbm('testing').only_with(
          {
            'ensure'     => 'present',
            'provider'   => 'policy',
            'collection' => 'MANDATORY',
            'group'      => 'MANDATORY',
          },
        )
      end
    end

    context "on #{os} with ensure set to absent" do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_hbm('testing').with_ensure('absent') }
    end

    context "on #{os} with collection set to TEST" do
      let(:params) { { collection: 'TEST' } }

      it { is_expected.to contain_hbm('testing').with_collection('TEST') }
    end

    context "on #{os} with group set to TEST" do
      let(:params) { { group: 'TEST' } }

      it { is_expected.to contain_hbm('testing').with_group('TEST') }
    end

    context "on #{os} with ensure set to invalid" do
      let(:params) { { ensure: 'invalid' } }

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{hbm::manage::policy::testing::ensure is invalid and does not match the regex.})
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with collection set to invalid #{param} (as #{param.class})" do
        let(:params) { { collection: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{is not a string})
        end
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with group set to invalid #{param} (as #{param.class})" do
        let(:params) { { group: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{is not a string})
        end
      end
    end
  end
end
