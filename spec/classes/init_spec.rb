require 'spec_helper'
describe 'hbm' do
  on_supported_os.sort.each do |os, os_facts|
    context "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.not_to contain_package('package_hbm') }

      it do
        is_expected.to contain_service('service_hbm').only_with(
          {
            'ensure' => 'running',
            'name'   => 'hbm',
            'enable' => true,
          },
        )
      end

      it { is_expected.not_to contain_class('hbm::manage::collection') }
      it { is_expected.not_to contain_class('hbm::manage::config') }
      it { is_expected.not_to contain_class('hbm::manage::group') }
      it { is_expected.not_to contain_class('hbm::manage::policy') }
      it { is_expected.not_to contain_class('hbm::manage::resource') }
      it { is_expected.not_to contain_class('hbm::manage::user') }
    end

    context "on #{os} with manage_package set to true" do
      let(:params) { { manage_package: true } }

      it do
        is_expected.to contain_package('package_hbm').only_with(
          {
            'ensure' => 'installed',
            'name'   => 'hbm',
            'before' => ['Service[service_hbm]'],
          },
        )
      end
    end

    context "on #{os} with manage_service set to false" do
      let(:params) { { manage_service: false } }

      it { is_expected.not_to contain_service('service_hbm') }
    end

    context "on #{os} with manage_package set to true when manage_service is set to false" do
      let(:params) do
        {
          manage_package: true,
          manage_service: false,
        }
      end

      it do
        is_expected.to contain_package('package_hbm').only_with(
          {
            'ensure' => 'installed',
            'name'   => 'hbm',
          },
        )
      end

      it { is_expected.not_to contain_service('service_hbm') }
    end

    context "on #{os} with service_enable set to false" do
      let(:params) { { service_enable: false } }

      it { is_expected.to contain_service('service_hbm').with_enable(false) }
    end

    context "on #{os} with service_ensure set to stopped" do
      let(:params) { { service_ensure: 'stopped' } }

      it { is_expected.to contain_service('service_hbm').with_ensure('stopped') }
    end

    context "on #{os} with collections set to valid hash" do
      let(:params) { { collections: { 'testing' => { 'ensure' => 'present' } } } }

      it { is_expected.to have_hbm__manage__collection_resource_count(1) }
      it { is_expected.to contain_hbm__manage__collection('testing').only_with_ensure('present') }

      # only needed to reach 100% resource coverage
      it { is_expected.to contain_hbm('testing') }
    end

    context "on #{os} with configs set to valid hash" do
      let(:params) { { configs: { 'testing' => { 'ensure' => 'present' } } } }

      it { is_expected.to have_hbm__manage__config_resource_count(1) }
      it { is_expected.to contain_hbm__manage__config('testing').only_with_ensure('present') }
    end

    context "on #{os} with groups set to valid hash" do
      let(:params) { { groups: { 'testing' => { 'ensure' => 'present' } } } }

      it { is_expected.to have_hbm__manage__group_resource_count(1) }
      it { is_expected.to contain_hbm__manage__group('testing').only_with_ensure('present') }
    end

    context "on #{os} with policies set to valid hash" do
      let(:params) { { policies: { 'testing' => { 'ensure' => 'present', 'collection' => 'TESTING', 'group' => 'Testing' } } } }

      it { is_expected.to have_hbm__manage__policy_resource_count(1) }

      it do
        is_expected.to contain_hbm__manage__policy('testing').only_with(
          {
            'ensure'     => 'present',
            'collection' => 'TESTING',
            'group'      => 'Testing',
          },
        )
      end
    end

    context "on #{os} with resources set to valid hash" do
      let(:params) { { resources: { 'testing' => { 'ensure' => 'present', 'type' => 'TESTING', 'value' => 'Testing', 'options' => ['TESTing'], 'members' => ['testING'] } } } }

      it { is_expected.to have_hbm__manage__resource_resource_count(1) }

      it do
        is_expected.to contain_hbm__manage__resource('testing').only_with(
          {
            'ensure'  => 'present',
            'type'    => 'TESTING',
            'value'   => 'Testing',
            'options' => [ 'TESTing' ],
            'members' => [ 'testING' ],
          },
        )
      end
    end

    context "on #{os} with members set to valid hash" do
      let(:params) { { users: { 'testing' => { 'ensure' => 'present', 'members' => [ 'TESTING' ] } } } }

      it { is_expected.to have_hbm__manage__user_resource_count(1) }

      it do
        is_expected.to contain_hbm__manage__user('testing').only_with(
          {
            'ensure'  => 'present',
            'members' => [ 'TESTING' ],
          },
        )
      end
    end

    context "on #{os} with unsupported version of docker" do
      let(:facts) do
        os_facts.merge(
          {
            docker_version: '1.11.0',
          },
        )
      end

      it 'fail' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{HBM requires Docker Engine version >=1.12.0. Your version is 1.11.0.})
      end
    end
  end
end
