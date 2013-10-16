name "orvsd_wordpress"
description "orvsd wordpress web server role"
run_list(
  "recipe[orvsd-web::wordpress]"
)
override_attributes(
    "nginx" => {
        "repo_source" => "nginx"
    }
)
