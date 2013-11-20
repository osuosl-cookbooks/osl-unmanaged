name "nginx"
description "Base role for nginx server"
run_list(
  "recipe[base::http]",
  "recipe[firewall::http]",
  "recipe[monitoring::nginx]"
) 
override_attributes(
)
