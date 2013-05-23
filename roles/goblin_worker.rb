name "goblin_worker"
description "goblin worker role"
run_list(
  "role[base_managed]",
  "recipe[goblin::worker]"
)
default_attributes(
)
override_attributes(
"openssh" => {
    "server" => {
      "password_authentication" => "no"
    }
  },
)
