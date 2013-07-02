name "postgres"
description "postgresql server role"
run_list(
    "role[base_managed]",
    "recipe[postgresql]",
    "recipe[firewall::postgres]"
)
default_attributes(
)
override_attributes(
)
