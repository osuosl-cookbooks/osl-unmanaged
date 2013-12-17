name "nodejs"
description "nodejs for nodejs web nodes"
run_list(
  "role[base::managed]",
  "recipe[osl-nodejs::default]"
)
