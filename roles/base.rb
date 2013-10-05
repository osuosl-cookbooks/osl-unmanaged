name "base"
description "base role for all systems"
run_list(
  "recipe[base::unmanaged]"
)
