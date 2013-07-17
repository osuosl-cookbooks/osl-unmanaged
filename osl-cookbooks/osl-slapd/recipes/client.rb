package "openldap-clients" do
  action :install
end

directory "#{node['osl-slapd']['dir']}" do
  action :create
end

ldap_hosts = ''
if Chef::Config[:solo]
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
    ldap_hosts = ['ldaps://localhost']
else
  search(:node, "roles:#{node['osl-slapd']['server_role']}") do |node|
    ldap_hosts << "ldaps://#{node['fqdn']} "
  end

  # on the first run, search isn't available, so if you're the nagios server, go
  # ahead and put your own IP address in iptables config.
  if node.run_list.roles.include?(node['osl-slapd']['server_role'])
    unless ldap_hosts.include?("ldaps://#{node['fqdn']}")
      ldap_hosts << "ldaps://#{node['fqdn']} "
    end
  end
end

node.default['osl-slapd']['uri'] = ldap_hosts

template "#{node['osl-slapd']['dir']}/ldap.conf" do
  source "ldap.conf.erb"
  mode 00644
end
