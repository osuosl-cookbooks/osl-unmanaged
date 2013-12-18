name "project_internal"
description "role for all internal servers"
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "destination-dir" => "/data/rdiff-backup-internal",
    }
  }
)
