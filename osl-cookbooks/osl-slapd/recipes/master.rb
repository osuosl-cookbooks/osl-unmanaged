node.default['osl-slapd']['slapd_type'] = 'master'

include_recipe "osl-slapd::server"
