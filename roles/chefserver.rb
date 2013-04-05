name "chefserver"
description "ermahgerd chef server role"
run_list(
  "role[base]",
  "recipe[firewall::http]"
)
