include_recipe 'provision_test::dns'

jenkins_plugin 'ssh-slaves' do
  notifies :restart, 'service[jenkins]', :immediately
end

jenkins_ssh_slave 'dns_master' do
  remote_fs '/home/alfred/jenkins'
  host 'ns-master.osuosl.org'
  user 'alfred'
  credentials 'alfred'
end
