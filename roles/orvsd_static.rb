name "orvsd_static"
description "orvsd static web server role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::static]"
)
override_attributes(
  "orvsdweb" => {
    "static" => {
      "glusterpath" => "/data",
      "glustervol" => "fs1.orvsd.bak:/media",
      "server_name" => "media.orvsd.org",
      "root" => "/data/breitenbush/media.orvsd.org"
    }
  },
  "nagios" => {
    "check_vhost" => {
      "server_name" => "media.orvsd.org"
    }
  }
)
