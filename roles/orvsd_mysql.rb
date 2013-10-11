name "orvsd_mysql"
description "ORVSD mysql server role"
run_list(
  "recipe[osl-mysql::orvsd]",
  "role[mysql]"
)
