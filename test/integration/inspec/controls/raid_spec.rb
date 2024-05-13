megacli = input('megacli', value: false)
mdadm = input('mdadm', value: false)
os_family = os.family
release = os.release
mdadm_conf =
  case os_family
  when 'redhat', 'fedora'
    '/etc/mdadm.conf'
  when 'debian'
    '/etc/mdadm/mdadm.conf'
  end

control 'raid' do
  if mdadm
    describe package 'mdadm' do
      it { should be_installed }
    end

    describe file mdadm_conf do
      its('content') { should match /^MAILADDR mdadm@osuosl.org$/ }
    end

    describe file '/usr/bin/megacli' do
      it { should_not exist }
    end

    case os_family
    when 'redhat', 'fedora'
      describe service 'mdmonitor-oneshot.timer' do
        it { should be_enabled }
        it { should be_running }
      end
      describe service 'mdmonitor-oneshot.service' do
        it { should be_enabled }
      end
    else
      describe service 'mdmonitor.service' do
        it { should be_enabled }
        it { should be_running }
      end
    end
  elsif megacli
    describe apt 'https://hwraid.le-vert.net/debian' do
      it { should exist }
      it { should be_enabled }
    end if os_family == 'debian' && release.to_f < 24.04

    describe command 'megacli -v' do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /MegaCLI SAS RAID Management Tool/ }
    end if release.to_f < 24.04
  end
end
