name "base_managed"
description "base managed role for all managed systems"
run_list(
  "recipe[base::managed]"
)
