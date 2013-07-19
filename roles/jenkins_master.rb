name "jenkins_master"
description "leeroy!"
run_list(
  "role[base_managed]",
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
