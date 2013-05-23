name "goblin_frontend"
description "goblin front end role"
run_list(
  "role[base_managed]",
  "recipe[goblin::django]"
)
default_attributes(
)
override_attributes(
"openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  },
)
