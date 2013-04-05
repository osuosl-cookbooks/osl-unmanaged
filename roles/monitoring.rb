name "monitoring"
description "monitoring server role"
run_list(
  "role[base]",
  "recipe[nagios::server]",
  "recipe[firewall::http]"
)
default_attributes(
  "nagios" => {
    "server_auth_method" => "ldap"
  }
)
