node.default['osl-slapd']['slapd_type'] = 'slave'

if Chef::Config[:solo]
  Chef::Log.warn("To use #{cookbook_name}::#{recipe_name} with solo, set attributes node['osl-slapd']['slapd_replpw'] and node['osl-slapd']['slapd_master'].")
else
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.default['osl-slapd']['slapd_replpw'] = secure_password
  node.default['osl-slapd']['slapd_master'] = search(:node, 'osl-slapd_slapd_type:master').map {|n| n['fqdn']}.first
  node.save
end

include_recipe "osl-slapd::server"
