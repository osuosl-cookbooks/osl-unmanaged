require_relative '../../spec_helper'

describe 'osl-unmanaged::raid' do
  def megacli_node(platform, version)
    ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
      node.automatic['kernel']['modules'] = { 'megaraid_sas' => {} }
    end.converge('osl-unmanaged::raid')
  end

  context 'debian 13' do
    cached(:chef_run) { megacli_node('debian', '13') }

    it 'creates the keyrings directory' do
      expect(chef_run).to create_directory('/etc/apt/keyrings')
    end

    it 'downloads the hwraid signing key' do
      expect(chef_run).to create_remote_file('/etc/apt/keyrings/hwraid.asc').with(
        source: 'https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key'
      )
      expect(chef_run.remote_file('/etc/apt/keyrings/hwraid.asc')).to \
        notify('apt_update[hwraid]').to(:update).immediately
    end

    it 'writes a signed-by repository entry for the node codename' do
      expect(chef_run).to create_file('/etc/apt/sources.list.d/hwraid.list').with(
        content: 'deb [signed-by=/etc/apt/keyrings/hwraid.asc] ' \
                 "https://hwraid.le-vert.net/debian trixie main\n"
      )
    end

    it 'does not use apt_repository, which imports keys with apt-key' do
      expect(chef_run).to_not add_apt_repository('hwraid')
    end

    it 'installs megacli' do
      expect(chef_run).to install_package(%w(megacli))
    end
  end

  context 'debian 12' do
    cached(:chef_run) { megacli_node('debian', '12') }

    it 'pins the repository to the bullseye suite' do
      expect(chef_run).to create_file('/etc/apt/sources.list.d/hwraid.list').with(
        content: 'deb [signed-by=/etc/apt/keyrings/hwraid.asc] ' \
                 "https://hwraid.le-vert.net/debian bullseye main\n"
      )
    end
  end

  context 'ubuntu 22.04' do
    cached(:chef_run) { megacli_node('ubuntu', '22.04') }

    it 'pins the repository to the bullseye suite' do
      expect(chef_run).to create_file('/etc/apt/sources.list.d/hwraid.list').with(
        content: 'deb [signed-by=/etc/apt/keyrings/hwraid.asc] ' \
                 "https://hwraid.le-vert.net/debian bullseye main\n"
      )
    end
  end

  context 'ubuntu 24.04' do
    cached(:chef_run) { megacli_node('ubuntu', '24.04') }

    it 'does not set up the hwraid repository' do
      expect(chef_run).to_not create_file('/etc/apt/sources.list.d/hwraid.list')
    end
  end
end
