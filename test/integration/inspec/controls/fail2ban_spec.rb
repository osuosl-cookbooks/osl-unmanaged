iptables_pkg = os.name == 'fedora' ? 'iptables-legacy' : 'iptables'

control 'fail2ban' do
  ['fail2ban', iptables_pkg].each do |p|
    describe package p do
      it { should be_installed }
    end
  end

  describe file '/etc/fail2ban/jail.local' do
    it { should exist }
    its('content') { should match /^ignoreip = fir.osuosl.org nagios.osuosl.org nagios2.osuosl.org$/ }
  end
end
