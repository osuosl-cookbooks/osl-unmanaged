platform = os.name
family = os.family
arch = os.arch
codename = inspec.command('lsb_release -cs').stdout.strip
packer = input('packer')
docker = inspec.command('test -e /.dockerenv')

control 'repos' do
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
      it { should be_enabled }
      if packer
        it { should_not be_enabled }
      end
    end
  when 'redhat'
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
    when 'ppc64le'
      describe apt 'http://ports.ubuntu.com/ubuntu-ports/' do
        it { should exist }
        it { should be_enabled }
      end
    end
  when 'ubuntu'
    case arch
    when 'x86_64'
      describe apt 'https://ubuntu.osuosl.org/ubuntu' do
        it { should exist }
        it { should be_enabled }
      end
    when 'ppc64le'
      describe apt 'http://ports.ubuntu.com/ubuntu-ports/' do
        it { should exist }
        it { should be_enabled }
      end
    end

    describe file '/etc/apt/sources.list' do
      its('content') { should match /ubuntu #{codename} (main|universe|multiverse)/ }
      its('content') { should match /ubuntu #{codename}-security (main|universe|multiverse)/ }
    end if arch == 'x86_64'
  when 'centos'
    describe yum.repo 'appstream' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://centos.osuosl.org/8-stream/AppStream/#{arch}/os/" }
    end

    describe yum.repo 'baseos' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://centos.osuosl.org/8-stream/BaseOS/#{arch}/os/" }
    end

    describe yum.repo 'epel' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://epel.osuosl.org/8/Everything/#{arch}/" }
    end

    describe yum.repo 'epel-modular' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://epel.osuosl.org/8/Modular/#{arch}/" }
    end

    describe yum.repo 'epel-next' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://epel.osuosl.org/next/8/Everything/#{arch}/" }
    end

    describe yum.repo 'extras' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://centos.osuosl.org/8-stream/extras/#{arch}/os/" }
    end

    describe yum.repo 'powertools' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://centos.osuosl.org/8-stream/PowerTools/#{arch}/os/" }
    end
  end
end
