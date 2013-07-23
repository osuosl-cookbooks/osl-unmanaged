name "racktables"
description "ermahgerd racktables"
run_list(
  "role[base_managed]",
  "recipe[racktables]",
  "recipe[certificate::wildcard]",
  "recipe[firewall::http]"
)
override_attributes(
  "racktables" => {
    "ssl_enabled" => true,
    "redirect_http" => true,
    "cert_path" => "/etc/pki/tls/certs/wildcard.pem",
    "key_path" => "/etc/pki/tls/private/wildcard.key"
  }
)
