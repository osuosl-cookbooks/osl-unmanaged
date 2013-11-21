name "orvsd_jenkins"
description "orvsd jenkins role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::jenkins]",
  "role[apache]"
)
override_attributes(
    "jenkins" => {
        "http_proxy" => {
            "ssl" => {
                "enabled" => true,
                "redirect_http" => true,
                "dir" => "/etc/pki/tls/certs",
                "cert_path" => "/etc/pki/tls/certs/_.orvsd.org.crt",
                "key_path" => "/etc/pki/tls/private/orvsd.key"
            }
        }
    }
)

