name "orvsd_wordpress"
description "orvsd wordpress web server role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::wordpress]"
)
override_attributes(
)
