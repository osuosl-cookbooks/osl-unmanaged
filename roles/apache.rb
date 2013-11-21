name "apache"
description "Base role for apache server"
run_list(
  "recipe[base::http]",
  "recipe[firewall::http]",
  "recipe[monitoring::apache]"
) 
override_attributes(
    "apache2" => {
        "default_site_enabled" => "true"
    }
)
