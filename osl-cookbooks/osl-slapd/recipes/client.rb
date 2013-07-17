package "openldap-clients" do
  action :install
end

directory "#{node['osl-slapd']['dir']}" do
  action :create
end

if Chef::Config[:solo]
  Chef::Log.warn("To use #{cookbook_name}::#{recipe_name} with solo, set attribute node['osl-slapd']['uri'].")
else
  ldap_hosts = Array.new
  search(:node, "roles:#{node['osl-slapd']['server_role']}") do |node|
    ldap_hosts.push("ldaps://#{node['fqdn']}")
  end
  node.default['osl-slapd']['uri'] = ldap_hosts.sort.join(", ")
end


template "#{node['osl-slapd']['dir']}/ldap.conf" do
  source "ldap.conf.erb"
  mode 00644
end
