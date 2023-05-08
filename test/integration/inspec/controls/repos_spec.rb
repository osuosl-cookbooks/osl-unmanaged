platform = os.name
family = os.family
arch = os.arch
codename = inspec.command('lsb_release -cs').stdout.strip
packer = input('packer')
docker = inspec.command('test -e /.dockerenv')

control 'repos' do
  describe service 'osuosl-firstboot.service' do
    it { should be_enabled }
    it { should_not be_running }
  end

  describe file '/usr/local/libexec/firstboot.sh' do
    its('mode') { should cmp '0755' }
    case family
    when 'debian'
      its('content') { should match /systemctl unmask apt-daily-upgrade.service apt-daily.service/ }
      its('content') do
        should match /systemctl enable --now unattended-upgrades.service apt-daily-upgrade.timer apt-daily-upgrade.service/
      end
    when 'redhat', 'fedora'
      its('content') { should match /systemctl enable --now dnf-automatic-install.timer/ }
    end
  end

  case family
  when 'debian'
    %w(
      apt-transport-https
      dirmngr
      gnupg
      unattended-upgrades
    ).each do |p|
      describe package p do
        it { should be_installed }
      end
    end

    describe service 'unattended-upgrades.service' do
      if packer
        it { should_not be_enabled }
      else
        it { should be_enabled }
      end
      it { should_not be_running }
    end

    describe service 'apt-daily-upgrade.timer' do
      if packer
        it { should_not be_enabled }
      else
        it { should be_enabled }
      end
    end
  when 'redhat', 'fedora'
    describe package 'dnf-automatic' do
      it { should be_installed }
    end

    describe service 'dnf-automatic-install.timer' do
      it { should be_enabled }
      it { should_not be_running }
    end
  end

  case platform
  when 'debian'
    case arch
    when 'x86_64'
      describe apt 'https://debian.osuosl.org/debian' do
        it { should exist }
        it { should be_enabled }
      end
      describe apt 'https://deb.debian.org/debian-security' do
        it { should exist }
        it { should be_enabled }
      end if docker
    end
  when 'ubuntu'
    case arch
    when 'x86_64'
      describe apt 'https://ubuntu.osuosl.org/ubuntu' do
        it { should exist }
        it { should be_enabled }
      end

      describe file '/etc/apt/sources.list' do
        its('content') { should match /ubuntu #{codename} (main|universe|multiverse)/ }
        its('content') { should match /ubuntu #{codename}-security (main|universe|multiverse)/ }
      end
    when 'ppc64le', 'aarch64'
      describe apt 'http://ports.ubuntu.com/ubuntu-ports' do
        it { should exist }
        it { should be_enabled }
      end
    end
  end
end
