name "monitoring"
description "monitoring server role"
run_list(
  "role[base]",
  "recipe[nagios::server]",
  "recipe[firewall::http]"
)
default_attributes(
  "nagios" => {
    "server" => {
      "install_method" => "package"
    },
    "server_auth_method" => "ldap",
    "ldap_bind_dn" => "cn=nagios,ou=web,ou=Group,dc=osuosl,dc=org",
    "ldap_url" => "ldaps://ldap1.osuosl.org:636/ou=People,dc=osuosl,dc=org?uid?sub?(objectClass=*)"
  }
)
