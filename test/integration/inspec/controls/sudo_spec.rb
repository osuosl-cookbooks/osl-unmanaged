control 'sudo' do
  describe package 'sudo' do
    it { should be_installed }
  end

  describe directory '/etc/sudoers.d' do
    it { should exist }
    its('mode') { should cmp '0750' }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'root' }
  end

  describe file '/etc/sudoers' do
    its('content') { should_not match /requiretty/ }
    its('content') { should match %r{^#includedir /etc/sudoers\.d$} }
  end

  describe command 'sudo -l' do
    its('stdout') { should_not match /requiretty/ }
    # sudo-rs warns on stderr about sudoers parse issues (e.g. missing trailing newline)
    its('stderr') { should eq '' }
  end

  # sudo-rs requires sudoers files to end with a newline
  inspec.command('ls /etc/sudoers.d').stdout.split.each do |f|
    describe file "/etc/sudoers.d/#{f}" do
      its('content') { should match /\n\z/ }
    end
  end
end
