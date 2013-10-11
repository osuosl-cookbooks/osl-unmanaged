name "mysql"
description "mysql server role"
run_list(
  "recipe[osl-mysql::server]",
  "role[base_managed]",
  "recipe[firewall::mysql]",
  "recipe[monitoring::mysql]"
)
