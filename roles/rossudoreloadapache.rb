name "rossudoreloadapache"
description "lets the ros user reload apache"
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => [
        "ros"
      ],
      "passwordless" => "true",
      "commands" => [
        "service httpd reload"
      ]
    }
  }
)
