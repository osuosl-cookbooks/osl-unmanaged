name "puppetmaster"
description "puppetmaster server role used for managing workstations"
run_list(
  "role[base_managed]",
  "recipe[firewall::puppetmaster]"
)
