admin_user = node['openstack']['identity']['admin_user']
admin_project = node['openstack']['identity']['admin_project']

# Set the m1.nano flavor to be 128M of ram as 64M is too small on ppc64le
edit_resource(:ruby_block, 'Create nano flavor 99') do
  block do
    begin
      env = openstack_command_env(admin_user, admin_project, 'Default', 'Default')
      output = openstack_command('nova', 'flavor-list', env)
      openstack_command('nova', 'flavor-create m1.nano 99 128 0 1', env) unless output.include? 'm1.nano'
    rescue RuntimeError => e
      Chef::Log.error("Could not create flavor m1.nano. Error was #{e.message}")
    end
  end
end
