name "rdiff_backup_dev"
description "role for all servers in dev environments to be backed up with rdiff-backup"
run_list(
  "role[rdiff_backup]"
)
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "retention-period" => "5D",
      "user" => "rdiff-backup-client-dev"
    }
  }
)
