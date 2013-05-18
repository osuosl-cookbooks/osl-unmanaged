name "goblin_backend"
description "goblin backend server role"
run_list(
  "role[base_managed]",
  "recipe[goblin::backend]"
)
default_attributes(
)
override_attributes(
  "postgresql" => {
    "config_pgtune" => {
      "db_type" => "web"
    }
  }
)
