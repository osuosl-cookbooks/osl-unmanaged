name "puppetmaster"
description "puppetmaster server role used for puppet masters"
run_list(
  "role[base_managed]",
  "recipe[firewall::puppetmaster]"
)
