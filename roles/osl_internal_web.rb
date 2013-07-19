name "osl_internal_web"
description "ermahgerd internal web services"
run_list(
  "role[base_managed]",
  "recipe[osl-slapd::client]",
  "recipe[firewall::http]",
  "recipe[apache2]",
  "recipe[apache2::mod_ssl]",
  "recipe[apache2::mod_php5]",
  "recipe[racktables]",
  "recipe[java::openjdk]",
  "recipe[jenkins]",
  "recipe[jenkins::proxy_apache2]"
)
override_attributes(
  "jenkins" => {
    "http_proxy" => {
      "variant" => "apache2",
      "host_name" => "jenkins.osuosl.org"
    }
  }
)
