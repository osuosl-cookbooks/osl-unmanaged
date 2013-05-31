name "goblin_frontend"
description "goblin front end role"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[goblin::django]"
)
override_attributes(
"openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  }
)
