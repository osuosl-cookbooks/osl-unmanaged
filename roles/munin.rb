name "munin"
description "munin server role"
run_list(
  "role[base_managed]",
  "recipe[osl-munin::server]"
)
