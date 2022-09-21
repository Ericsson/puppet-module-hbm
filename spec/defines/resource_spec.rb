require 'spec_helper'
describe 'hbm::manage::resource' do
  let(:title) { 'testing' }

  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_hbm('testing').only_with(
          {
            'ensure'     => 'present',
            'provider'   => 'resource',
            'type'       => nil,
            'value'      => nil,
            'options'    => [],
            'members'    => [],
          },
        )
      end
    end

    context "on #{os} with ensure set to absent" do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_hbm('testing').with_ensure('absent') }
    end

    context "on #{os} with type set to TEST" do
      let(:params) { { type: 'TEST' } }

      it { is_expected.to contain_hbm('testing').with_type('TEST') }
    end

    context "on #{os} with value set to TEST" do
      let(:params) { { value: 'TEST' } }

      it { is_expected.to contain_hbm('testing').with_value('TEST') }
    end

    context "on #{os} with options set to [ TEST ]" do
      let(:params) { { options: [ 'TEST' ] } }

      it { is_expected.to contain_hbm('testing').with_options(['TEST']) }
    end

    context "on #{os} with members set to [ TEST ]" do
      let(:params) { { members: [ 'TEST' ] } }

      it { is_expected.to contain_hbm('testing').with_members(['TEST']) }
    end

    context "on #{os} with ensure set to invalid" do
      let(:params) { { ensure: 'invalid' } }

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a match for Enum})
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with type set to invalid #{param} (as #{param.class})" do
        let(:params) { { type: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a value of type Undef or String})
        end
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with value set to invalid #{param} (as #{param.class})" do
        let(:params) { { value: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a value of type Undef or String})
        end
      end
    end

    ['string', { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with options set to invalid #{param} (as #{param.class})" do
        let(:params) { { options: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects an Array value})
        end
      end
    end

    ['string', { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with members set to invalid #{param} (as #{param.class})" do
        let(:params) { { members: param } }

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects an Array value})
        end
      end
    end
  end
end
