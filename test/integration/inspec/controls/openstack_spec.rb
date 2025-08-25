ppc64le = os.arch == 'ppc64le'
aarch64 = os.arch == 'aarch64'
x86 = os.arch == 'x86_64'
os_family = os.family
os_release = os.release.to_i
os_name = os.name
grub_path =
  case os_family
  when 'redhat'
    if aarch64
      "/boot/efi/EFI/#{os_name}"
    else
      '/boot/grub2'
    end
  when 'debian'
    '/boot/grub'
  end
openstack_services =
  if os_name == 'debian' && (os_release >= 13 || os.release.match?(/sid/))
    %w(
      cloud-config
      cloud-final
      cloud-init-hotplugd
      cloud-init-local
      cloud-init-main
      cloud-init-network
    )
  else
    %w(
      cloud-config
      cloud-final
      cloud-init
      cloud-init-local
    )
  end
openstack = input('openstack', value: false)
docker = inspec.command('test -e /.dockerenv')

control 'openstack' do
  only_if { openstack }
  case os_family
  when 'redhat'
    %w(
      cloud-init
      cloud-utils-growpart
      gdisk
    ).each do |p|
      describe package p do
        it { should be_installed }
      end
    end

    describe package 'ppc64-diag' do
      it { should be_installed }
    end if ppc64le

    describe file '/boot/grub2/grubenv' do
      if ppc64le && os_release < 9
        its('content') { should match /^kernelopts=.* console=hvc0,115200n8 console=tty0 crashkernel=auto rhgb quiet $/ }
      else
        its('content') { should match /^kernelopts=.* console=ttyS0,115200n8 console=tty0 crashkernel=auto rhgb quiet $/ }
      end
    end unless docker

  when 'debian'
    %w(
      cloud-utils
      cloud-init
      cloud-initramfs-growroot
    ).each do |p|
      describe package p do
        it { should be_installed }
      end
    end

    describe package 'powerpc-utils' do
      it { should be_installed }
    end if ppc64le
  end

  describe file '/etc/default/grub' do
    its('content') { should match /^GRUB_TIMEOUT=0$/ }
    case os_family
    when 'redhat'
      if os_release >= 9
        its('content') { should match /GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 no_timer_check"$/ }
      elsif ppc64le
        its('content') { should match /^GRUB_CMDLINE_LINUX="console=hvc0,115200n8 console=tty0 crashkernel=auto rhgb quiet"$/ }
      else
        its('content') { should match /GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 crashkernel=auto rhgb quiet"$/ }
      end
    when 'debian'
      if ppc64le
        its('content') { should match /^GRUB_CMDLINE_LINUX="console=hvc0,115200n8 console=tty0"$/ }
      else
        its('content') { should match /^GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0"$/ }
      end
    end
  end unless docker

  describe file "#{grub_path}/grub.cfg" do
    its('content') { should match /set timeout=0/ }
    if os_family == 'debian'
      if ppc64le && os_release < 9
        its('content') { should match /console=hvc0,115200n8 console=tty0/ }
      else
        its('content') { should match /console=ttyS0,115200n8 console=tty0/ }
      end
    end
  end unless docker

  describe file '/etc/cloud/cloud.cfg' do
    case os_name
    when 'centos'
      its('content') { should_not match /name: cloud-user/ }
      its('content') { should match /name: centos/ }
    when 'almalinux'
      its('content') { should_not match /name: cloud-user/ }
      its('content') { should match /name: almalinux/ }
    when 'fedora'
      its('content') { should_not match /name: cloud-user/ }
      its('content') { should match /name: fedora/ }
    when 'ubuntu'
      its('content') { should match %r{primary: https://ubuntu.osuosl.org/ubuntu$} }
    end
  end

  describe file '/etc/cloud/cloud.cfg.d/91_openstack_override.cfg' do
    if x86
      its('content') { should match /datasource_list: \[ConfigDrive, OpenStack, None\]/ }
    else
      its('content') { should match /datasource_list: \[OpenStack, None\]/ }
    end
    its('content') { should match %r{metadata_urls: \['http://169.254.169.254'\]} }
  end

  openstack_services.each do |s|
    describe service s do
      it { should be_enabled }
    end
  end
end
