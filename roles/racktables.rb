name "racktables"
description "ermahgerd racktables"
run_list(
  "role[base_managed]",
  "recipe[firewall::http]",
  "recipe[racktables]"
)
