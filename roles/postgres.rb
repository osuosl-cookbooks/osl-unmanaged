name "postgres"
description "postgresql server role"
run_list(
    "role[base_managed]",
    "recipe[osl-postgresql::mount]",
    "recipe[osl-postgresql::server]"
)
