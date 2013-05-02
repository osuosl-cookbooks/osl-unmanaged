name "orvsd_static"
description "orvsd static web server role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::static]"
)
override_attributes(
  "orvsdweb" => {
    "static" => {
      "root" => "/data/breitenbush/media.orvsd.org",
    }
  }
)
