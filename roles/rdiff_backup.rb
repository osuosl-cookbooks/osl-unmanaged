name "rdiff_backup"
description "role for all servers to be backed up with rdiff-backup"
run_list(
  "recipe[rdiff-backup::client]"
)
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "source-dirs" => [
        "/root",
        "/home",
        "/etc",
        "/opt",
        "/var",
        "/srv"
      ],
      "exclude-dirs" => [
        "/var/cache",
        "/var/cfengine",
        "/var/chef",
        "/var/lib/denyhosts",
        "/var/lib/slocate",
        "/var/lib/mysql",
        "/var/log",
        "/var/spool",
        "/var/tmp"
      ],
      "destination-dir" => "/data/rdiff-backup",
      "user" => "rdiff-backup-client",
      "retention-period" => "3M",
      "nagios-maxchange" => 10000
    }
  }
)
