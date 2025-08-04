docker = inspec.command('hostnamectl chassis').stdout == 'container'

control 'chrony' do
  describe service 'chronyd' do
    it { should be_enabled }
    it { should be_running } if docker
  end

  describe port 323 do
    it { should_not be_listening }
  end
end
