name "orvsd_static"
description "orvsd static web server role"
run_list(
  "role[base_managed]",
  "recipe[orvsd-web::static]",
  "recipe[nginx::http_realip_module]"
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
  },
  "nginx" => {
    "realip" => {
      "addresses" => [
        "140.211.15.203",
        "140.211.15.204"
      ]
    }
  }
)
