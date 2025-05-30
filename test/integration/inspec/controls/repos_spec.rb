platform = os.name
family = os.family
release = os.release
arch = os.arch
release = os.release.to_i
codename = inspec.command('lsb_release -cs').stdout.strip
packer = input('packer')
docker = inspec.command('test -e /.dockerenv')
sources_list = inspec.file('/etc/apt/sources.list').exist?
power9 = inspec.command('lscpu').stdout.match(/POWER9/)

base_arch =
  if power9
    'power9'
  else
    arch
  end

centos7_url =
  case arch
  when 'aarch64', 'ppc64le'
    'https://centos-altarch.osuosl.org'
  else
    'https://centos.osuosl.org'
  end

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
      if release.to_i >= 8
        its('content') { should match /systemctl enable --now dnf-automatic-install.timer/ }
      else
        its('content') { should match /systemctl enable --now yum-cron.service/ }
      end
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
    if release.to_i >= 8
      describe package 'dnf-automatic' do
        it { should be_installed }
      end

      describe service 'dnf-automatic-install.timer' do
        it { should be_enabled }
        it { should_not be_running }
      end
    else
      describe package 'yum-cron' do
        it { should be_installed }
      end

      describe service 'yum-cron' do
        it { should be_enabled }
        it { should_not be_running }
      end
    end
  end

  case platform
  when 'debian'
    case arch
    when 'x86_64'
      describe apt 'https://debian.osuosl.org/debian' do
        it { should exist }
        it { should be_enabled }
      end if sources_list
      describe apt 'https://deb.debian.org/debian-security' do
        it { should exist }
        it { should be_enabled }
      end if docker && sources_list
    end
  when 'ubuntu'
    case arch
    when 'x86_64'
      describe apt 'https://ubuntu.osuosl.org/ubuntu' do
        it { should exist }
        it { should be_enabled }
      end if release.to_f < 24

      describe file '/etc/apt/sources.list' do
        its('content') { should match /ubuntu #{codename} (main|universe|multiverse)/ }
        its('content') { should match /ubuntu #{codename}-security (main|universe|multiverse)/ }
      end if release.to_f < 24

      describe file '/etc/apt/sources.list.d/ubuntu.sources' do
        its('content') { should match %r{URIs: https://ubuntu.osuosl.org/ubuntu} }
        its('content') { should match /Suites: #{codename} #{codename}-updates #{codename}-backports/ }
        its('content') { should match /Suites: #{codename}-security/ }
        its('content') { should match /Components:.*main/ }
        its('content') { should match /Components:.*universe/ }
        its('content') { should match /Components:.*restricted/ }
        its('content') { should match /Components:.*multiverse/ }
      end if release.to_f >= 24
    when 'ppc64le', 'aarch64'
      describe apt 'http://ports.ubuntu.com/ubuntu-ports' do
        it { should exist }
        it { should be_enabled }
      end if release.to_f < 24

      describe file '/etc/apt/sources.list.d/ubuntu.sources' do
        its('content') { should match %r{URIs: http://ports.ubuntu.com/ubuntu-ports} }
        its('content') { should match /Suites: #{codename} #{codename}-updates #{codename}-backports/ }
        its('content') { should match /Suites: #{codename}-security/ }
        its('content') { should match /Components:.*main/ }
        its('content') { should match /Components:.*universe/ }
        its('content') { should match /Components:.*restricted/ }
        its('content') { should match /Components:.*multiverse/ }
      end if release.to_f >= 24
    end
  when 'centos'
    case release.to_i
    when 7
      describe yum.repo 'base' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "#{centos7_url}/7/os/#{base_arch}/" }
      end

      describe yum.repo 'epel' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://epel.osuosl.org/7/#{arch}/" }
      end

      describe yum.repo 'extras' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "#{centos7_url}/7/extras/#{base_arch}/" }
      end

      describe yum.repo 'updates' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "#{centos7_url}/7/updates/#{base_arch}/" }
      end
    when 8
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
    when 10, 9
      describe yum.repo 'appstream' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://centos-stream.osuosl.org/9-stream/AppStream/#{arch}/os/" }
      end

      describe yum.repo 'baseos' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://centos-stream.osuosl.org/9-stream/BaseOS/#{arch}/os/" }
      end

      describe yum.repo 'epel' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://epel.osuosl.org/9/Everything/#{arch}/" }
      end

      describe yum.repo 'epel-next' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://epel.osuosl.org/next/9/Everything/#{arch}/" }
      end

      describe yum.repo 'extras-common' do
        it { should exist }
        it { should be_enabled }
        its('baseurl') { should cmp "https://centos-stream.osuosl.org/SIGs/9-stream/extras/#{arch}/extras-common/" }
      end
    end
  when 'almalinux'
    describe yum.repo 'appstream' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://almalinux.osuosl.org/#{release}/AppStream/#{arch}/os/" }
    end

    describe yum.repo 'baseos' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://almalinux.osuosl.org/#{release}/BaseOS/#{arch}/os/" }
    end

    describe yum.repo 'epel' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://epel.osuosl.org/#{release}/Everything/#{arch}/" }
    end

    describe yum.repo 'extras' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://almalinux.osuosl.org/#{release}/extras/#{arch}/os/" }
    end

    describe yum.repo 'powertools' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://almalinux.osuosl.org/#{release}/PowerTools/#{arch}/os/" }
    end if release == 8

    describe yum.repo 'crb' do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should cmp "https://almalinux.osuosl.org/#{release}/CRB/#{arch}/os/" }
    end if release >= 9

    %w(
      appstream
      baseos
      epel
      extras
      powertools
      crb
    ).each do |r|
      %w(debuginfo source).each do |t|
        describe yum.repo "#{r}-#{t}" do
          it { should_not be_enabled }
        end
      end
    end
  end
end
