name "goblin_backend"
description "goblin backend server role"
run_list(
  "role[base]",
  "recipe[goblin::backend]"
)
override_attributes(
  "postgresql" => {
    "config_pgtune" => {
      "db_type" => "web"
    }
  },
   "openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  }
)
