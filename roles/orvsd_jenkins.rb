name "orvsd_jenkins"
description "orvsd jenkins role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::jenkins]"
)
override_attributes(
)

