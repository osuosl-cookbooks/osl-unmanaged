name "monitoring"
description "monitoring server role"
run_list(
  "recipe[nagios::server]",
  "role[base_managed]",
  "recipe[firewall::http]",
  "recipe[ssh-ldap]"
)
default_attributes(
  "nagios" => {
    "server_auth_method" => "htpasswd"
    #"ldap_bind_dn" => "cn=nagios,ou=web,ou=Group,dc=osuosl,dc=org",
    #"ldap_url" => "ldaps://ldap1.osuosl.org:636/ou=People,dc=osuosl,dc=org?uid?sub?(objectClass=*)",
    #"ldap_authoritative" => "on"
  }
)
override_attributes(
  "nagios" => {
    "user" => "nagios",
    "group" => "nagios",
    "notifications_enabled" => "1",
    "host_name_attribute" => "fqdn",
    "default_contact_groups" => %w{osl_pager},
    "server" => {
      "install_method" => "source",
    }
  }
)
