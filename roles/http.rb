name "http"
description "Base role for http host"
run_list(
  "recipe[base::http]",
  "recipe[firewall::http]",
  "recipe[monitoring::http]"
) 
override_attributes(
)
