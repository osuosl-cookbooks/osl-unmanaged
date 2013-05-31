name "goblin_backend"
description "goblin backend server role"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[goblin::backend]"
)
override_attributes(
  "openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  }
)
