name "project_phpbb"
description "role for all phpBB servers"
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "destination-dir" => "/data/rdiff-backup-phpbb",
    }
  }
)
