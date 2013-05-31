name "goblin_worker"
description "goblin worker role"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[goblin::worker]"
)
override_attributes(
  "openssh" => {
    "server" => {
      "password_authentication" => "yes"
    }
  }
)
