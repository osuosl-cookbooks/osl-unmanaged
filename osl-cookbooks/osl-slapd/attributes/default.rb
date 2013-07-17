default['osl-slapd']['server_role'] = "openldap"
default['osl-slapd']['dir'] = "/etc/openldap"

default['osl-slapd']['TLSCertficateFile'] = "/etc/openldap/certs/ldap.pem"
default['osl-slapd']['TLSCertficateKeyFile'] = "/etc/openldap/certs/ldap.key"
default['osl-slapd']['TLSCACertficateFile'] = "/etc/openldap/certs/ldap-bundle.crt"

default['osl-slapd']['suffix'] = "dc=example,dc=com"
default['osl-slapd']['rootdn'] = "cn=Manager,#{node['osl-slapd']['suffix']}"
default['osl-slapd']['rootgroup'] = "cn=Admin"
default['osl-slapd']['rootgroupdn'] = "#{node['osl-slapd']['rootgroup']},#{node['osl-slapd']['suffix']}"
default['osl-slapd']['rootpw'] = ""

default['osl-slapd']['slapd_rid'] = "102"
