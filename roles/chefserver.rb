name "chefserver"
description "ermahgerd chef server role"
run_list(
  "role[base_managed]",
  "recipe[firewall::http]"
)
