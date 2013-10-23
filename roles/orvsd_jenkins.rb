name "orvsd_jenkins"
description "orvsd jenkins role"
run_list(
  "role[base_managed]",
  "recipe[jenkins::server]",
  "recipe[jenkins::proxy_apache2]"
)
override_attributes(
)

