name "racktables"
description "ermahgerd racktables"
run_list(
  "role[base_managed]",
  "recipe[racktables]",
  "recipe[certificate::wildcard]",
  "recipe[firewall::http]"
)
