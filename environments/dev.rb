name "dev"
description "The development environment"
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => ["vagrant"]
    }
  }
)
