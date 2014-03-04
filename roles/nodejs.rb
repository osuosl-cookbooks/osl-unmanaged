name "nodejs"
description "nodejs for nodejs web nodes"
run_list(
  "recipe[osl-nodejs::default]"
)
