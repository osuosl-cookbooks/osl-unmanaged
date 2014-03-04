name "nodejs"
description "nodejs for nodejs web nodes"
run_list(
  "recipe[osl-nodejs::default]"
)
default_attributes(
  "nodejs" => {
    "version" => "0.10.26"
  }
)
