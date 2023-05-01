family = os.family
arch = os.arch
ppc64le = os.arch == 'ppc64le'
rsct = input('rsct', value: false)

control 'rsct' do
  only_if { rsct }
  case family
  when 'redhat', 'fedora'
    %w(
      DynamicRM
      rsct.basic
      rsct.core
      src
    ).each do |p|
      describe package p do
        it { should be_installed }
      end
    end if ppc64le

    describe yum.repo 'IBM_Power_Tools' do
      it { should exist }
      it { should be_enabled } unless family == 'fedora' && arch == 'x86_64'
      if family == 'fedora'
        its('baseurl') { should cmp "https://public.dhe.ibm.com/software/server/POWER/Linux/yum/OSS/Fedora/#{arch}" }
      else
        its('baseurl') { should cmp "https://public.dhe.ibm.com/software/server/POWER/Linux/yum/OSS/RHEL/8/#{arch}" }
      end
    end
  when 'debian'
    %w(
      dynamicrm
      rsct.core
      rsct.core.utils
      src
    ).each do |p|
      describe package p do
        it { should be_installed }
      end
    end if ppc64le

    describe apt 'ibmpackages/rsct' do
      it { should exist }
      it { should be_enabled }
    end
  end

  describe command 'lssrc -a' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /ctrmc\s+rsct\s+[0-9]+\s+active/ }
    its('stdout') { should match /IBM.HostRM\s+rsct_rm\s+[0-9]+\s+active/ }
    its('stdout') { should match /IBM.DRM\s+rsct_rm\s+[0-9]+\s+active/ }
    its('stdout') { should match /IBM.MgmtDomainRM\s+rsct_rm\s+[0-9]+\s+active/ }
    its('stdout') { should match /ctcas\s+rsct\s+inoperative/ }
    its('stdout') { should match /IBM.ERRM\s+rsct_rm\s+inoperative/ }
    its('stdout') { should match /IBM.AuditRM\s+rsct_rm\s+inoperative/ }
    its('stdout') { should match /IBM.SensorRM\s+rsct_rm\s+inoperative/ }
  end if ppc64le

  %w(
    srcmstr.service
    rtas_errd.service
  ).each do |s|
    describe service s do
      it { should be_enabled }
      it { should be_running }
    end
  end if ppc64le
end
