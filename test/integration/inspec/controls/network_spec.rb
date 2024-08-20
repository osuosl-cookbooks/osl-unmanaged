platform = os.name
release = os.release.to_i
cleanup = input('cleanup')
docker = inspec.command('test -e /.dockerenv')
resolved = inspec.command('test -e /etc/systemd/resolved.conf')

control 'network' do
  case platform
  when 'ubuntu', 'debian'
    %w(network-manager isc-dhcp-client).each do |p|
      describe package p do
        it { should be_installed }
      end
    end

    describe ini '/etc/NetworkManager/NetworkManager.conf' do
      its('main.dns') { should cmp 'default' }
      its('main.dhcp') { should cmp 'internal' }
      its('main.systemd-resolved') { should cmp 'false' }
      its('main.rc-manager') { should cmp 'netconfig' }
      its('keyfile.unmanaged-devices') { should cmp 'interface-name:ibmveth3' }
    end

    %w(
      90_dpkg
      99-installer
      curtin-preserve-sources
      subiquity-disable-cloudinit-networking
    ).each do |f|
      describe file "/etc/cloud/cloud.cfg.d/#{f}.cfg" do
        it { should_not exist }
      end
    end

    describe file '/etc/netplan/00-installer-config.yaml' do
      it { should_not exist }
    end

    describe file '/etc/netplan/01-network-manager.yaml' do
      its('content') do
        should cmp <<~EOF
          network:
            version: 2
            renderer: NetworkManager
        EOF
      end
    end

    describe command 'netplan get' do
      its('stdout') { should match /renderer: NetworkManager/ }
      its('stdout') { should match /version: 2/ }
    end

    describe ini '/etc/systemd/resolved.conf' do
      its('Resolve.DNSStubListener') { should cmp 'no' }
    end if resolved

    describe file '/etc/apparmor.d/sbin.dhclient' do
      its('content') { should match %r{/run/NetworkManager/dhclient\{,6\}-\*\.pid lrw,$} }
      its('content') { should match %r{owner /proc/\*/task/\*\* rw,$} }
    end unless platform == 'debian'

    describe file '/var/lib/cloud/data/instance-id' do
      it { should_not exist }
    end

    describe service 'systemd-resolved.service' do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service 'systemd-networkd-wait-online.service' do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service 'NetworkManager' do
      it { should be_enabled }
      it { should be_running }
    end

    describe processes '/lib/systemd/systemd-resolved' do
      it { should_not exist }
    end

    describe file '/etc/resolv.conf' do
      if cleanup
        its('content') { should_not match /Generated by NetworkManager/ }
      elsif !docker
        its('content') { should match /Generated by NetworkManager/ }
      end
      its('type') { should_not eq :link }
      its('type') { should eq :file }
    end

    describe port 53  do
      it { should_not be_listening }
    end
  when 'centos', 'almalinux', 'fedora'
    if release >= 8
      describe package 'dhcp-client' do
        it { should be_installed }
      end
    else
      describe package 'dhclient' do
        it { should be_installed }
      end
    end

    describe ini '/etc/NetworkManager/NetworkManager.conf' do
      its('main.dns') { should cmp 'default' }
      its('main.dhcp') { should cmp 'internal' }
      its('main.systemd-resolved') { should cmp 'false' }
    end

    describe service 'systemd-resolved.service' do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service 'NetworkManager' do
      it { should be_enabled }
      it { should be_running }
    end

    describe processes '/lib/systemd/systemd-resolved' do
      it { should_not exist }
    end

    describe file '/etc/resolv.conf' do
      if cleanup
        its('content') { should_not match /Generated by NetworkManager/ }
      elsif !docker
        its('content') { should match /Generated by NetworkManager/ }
      end
      its('type') { should_not eq :link }
      its('type') { should eq :file }
    end

    describe port 53  do
      it { should_not be_listening }
    end
  end
end