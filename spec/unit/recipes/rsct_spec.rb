require_relative '../../spec_helper'

describe 'osl-unmanaged::rsct' do
  context 'ubuntu 24.04' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04').converge(described_recipe) }

    it 'creates the keyrings directory' do
      expect(chef_run).to create_directory('/etc/apt/keyrings')
    end

    it 'installs the vendored ppa signing key' do
      expect(chef_run).to create_cookbook_file('/etc/apt/keyrings/ibmpackages-rsct.asc')
      expect(chef_run.cookbook_file('/etc/apt/keyrings/ibmpackages-rsct.asc')).to \
        notify('apt_update[IBM_Power_Tools]').to(:update).immediately
    end

    it 'writes a signed-by repository entry for the node codename' do
      expect(chef_run).to create_file('/etc/apt/sources.list.d/IBM_Power_Tools.list').with(
        content: 'deb [signed-by=/etc/apt/keyrings/ibmpackages-rsct.asc] ' \
                 "http://ppa.launchpad.net/ibmpackages/rsct/ubuntu noble main\n"
      )
      expect(chef_run.file('/etc/apt/sources.list.d/IBM_Power_Tools.list')).to \
        notify('apt_update[IBM_Power_Tools]').to(:update).immediately
    end

    it 'does not use apt_repository, which imports keys with apt-key' do
      expect(chef_run).to_not add_apt_repository('IBM_Power_Tools')
    end

    it 'does not install packages on a non-ppc64le node' do
      expect(chef_run).to_not install_package(%w(rsct.core rsct.core.utils src))
    end
  end

  context 'debian 13' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'debian', version: '13').converge(described_recipe) }

    it 'pins the repository to the focal suite' do
      expect(chef_run).to create_file('/etc/apt/sources.list.d/IBM_Power_Tools.list').with(
        content: 'deb [signed-by=/etc/apt/keyrings/ibmpackages-rsct.asc] ' \
                 "http://ppa.launchpad.net/ibmpackages/rsct/ubuntu focal main\n"
      )
    end
  end

  context 'ubuntu 24.04 on ppc64le' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04') do |node|
        node.automatic['kernel']['machine'] = 'ppc64le'
      end.converge(described_recipe)
    end

    it 'installs the rsct packages' do
      expect(chef_run).to install_package(%w(rsct.core rsct.core.utils src))
    end
  end

  context 'almalinux 9' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'almalinux', version: '9').converge(described_recipe) }

    it 'creates the yum repository and leaves apt alone' do
      expect(chef_run).to create_yum_repository('IBM_Power_Tools').with(
        baseurl: 'https://public.dhe.ibm.com/software/server/POWER/Linux/yum/OSS/RHEL/$releasever/$basearch',
        gpgkey: 'file:///opt/ibm/lop/gpg/RPM-GPG-KEY-ibm-power'
      )
      expect(chef_run).to_not create_file('/etc/apt/sources.list.d/IBM_Power_Tools.list')
    end

    it 'does not install packages on a non-ppc64le node' do
      expect(chef_run).to_not install_package(%w(rsct.basic rsct.core src))
    end
  end

  context 'almalinux 10' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'almalinux', version: '10').converge(described_recipe) }

    it 'trusts the v2 signing key' do
      expect(chef_run).to create_yum_repository('IBM_Power_Tools').with(
        gpgkey: 'file:///opt/ibm/lop/gpg/RPM-GPG-KEY-ibm-power-v2'
      )
    end
  end

  context 'almalinux 10 on ppc64le' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'almalinux', version: '10') do |node|
        node.automatic['kernel']['machine'] = 'ppc64le'
      end.converge(described_recipe)
    end

    it 'installs the rsct packages, then DynamicRM' do
      expect(chef_run).to install_package(%w(rsct.basic rsct.core src))
      expect(chef_run).to install_package('DynamicRM')
    end
  end
end
