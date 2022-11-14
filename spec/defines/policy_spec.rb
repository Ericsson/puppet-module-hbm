require 'spec_helper'
describe 'hbm::manage::policy' do
  mandatory_params = {
    collection: 'unit',
    group:      'test',
  }
  let(:title) { 'testing' }

  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a value for parameter})
      end
    end

    context "on #{os} with mandatory values set" do
      let(:facts) { os_facts }
      let(:params) { mandatory_params }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_hbm('testing').only_with(
          {
            'ensure'     => 'present',
            'provider'   => 'policy',
            'collection' => 'unit',
            'group'      => 'test',
          },
        )
      end
    end

    context "on #{os} with ensure set to absent" do
      let(:params) do
        mandatory_params.merge({ ensure: 'absent' })
      end

      it { is_expected.to contain_hbm('testing').with_ensure('absent') }
    end

    context "on #{os} with collection set to TEST" do
      let(:params) do
        mandatory_params.merge({ collection: 'TEST' })
      end

      it { is_expected.to contain_hbm('testing').with_collection('TEST') }
    end

    context "on #{os} with group set to TEST" do
      let(:params) do
        mandatory_params.merge({ group: 'TEST' })
      end

      it { is_expected.to contain_hbm('testing').with_group('TEST') }
    end

    context "on #{os} with ensure set to invalid" do
      let(:params) do
        mandatory_params.merge({ ensure: 'invalid' })
      end

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a match for Enum})
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with collection set to invalid #{param} (as #{param.class})" do
        let(:params) do
          mandatory_params.merge({ collection: param })
        end

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a String value})
        end
      end
    end

    [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false].each do |param|
      context "on #{os} with group set to invalid #{param} (as #{param.class})" do
        let(:params) do
          mandatory_params.merge({ group: param })
        end

        it 'fail' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{expects a String value})
        end
      end
    end
  end
end
