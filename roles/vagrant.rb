name "vagrant"
description "vagrant role"
run_list(
  "role[base]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => ["vagrant"]
    }
  }
)
