name "goblin_backend"
description "goblin backend server role"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[goblin::backend]",
  "recipe[postgresql::config_pgtune]"
)
override_attributes(
  "postgresql" => {
    "config" => {
      "listen_address" => "*"
    },
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
