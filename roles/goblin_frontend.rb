name "goblin_frontend"
description "goblin front end role"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[goblin::apache]"
)
override_attributes(
"openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  }
)
