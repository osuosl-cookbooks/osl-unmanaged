name "project_orvsd"
description "role for all ORVSD servers"
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "destination-dir" => "/data/rdiff-backup-orvsd",
    }
  }
)
