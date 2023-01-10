docker = inspec.command('test -e /.dockerenv')

control 'chrony' do
  describe service 'chronyd' do
    it { should be_enabled }
    it { should be_running } unless docker
  end

  describe port 323 do
    it { should_not be_listening }
  end
end
