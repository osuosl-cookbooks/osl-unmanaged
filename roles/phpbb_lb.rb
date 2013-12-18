name "phpbb_lb"
description "phpbb load balancer"
run_list(
  "role[base_managed]",
  "recipe[phpbb::haproxy]"
)
