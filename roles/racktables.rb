name "racktables"
description "ermahgerd racktables"
run_list(
  "role[base_managed]",
  "recipe[firewall::http]",
  "recipe[apache2]",
  "recipe[apache2::mod_ssl]",
  "recipe[apache2::mod_php5]",
  "recipe[racktables]"
)
