name "osl_internal_web"
description "ermahgerd internal web services"
run_list(
  "role[base_managed]",
  "recipe[osl-slapd::client]",
  "recipe[firewall::http]",
  "recipe[certificate::wildcard]",
  "recipe[apache2]",
  "recipe[apache2::mod_ssl]",
  "recipe[apache2::mod_php5]",
  "recipe[racktables]",
  "recipe[java::openjdk]",
  "recipe[jenkins::server]",
  "recipe[jenkins::proxy_apache2]"
)
override_attributes(
  "jenkins" => {
    "http_proxy" => {
      "host_name" => "jenkins.osuosl.org",
      "ssl" => {
        "enabled" => true,
        "redirect_http" => true,
        "dir" => "/etc/pki/tls/certs",
        "cert_path" => "/etc/pki/tls/certs/wildcard.pem",
        "key_path" => "/etc/pki/tls/private/wildcard.key"
      }
    }
  }
)
