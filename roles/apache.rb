name "apache"
description "Base role for apache server"
run_list(
  "recipe[monitoring::http]"
) 
override_attributes(
)
