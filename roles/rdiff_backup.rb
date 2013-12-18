name "rdiff_backup"
description "role for all servers to be backed up with rdiff-backup"
run_list(
  "recipe[nagios::client]",
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
        "/var/lib/ntp",
        "/var/lib/slocate",
        "/var/lib/mysql",
        "/var/spool/postfix",
        "/var/lib/svn",
        "/var/svn",
        "/var/tmp",
        "/var/log",
        "/var/spool/cron/lastrun"
      ],
      "retention-period" => "3M",
      "nagios-maxchange" => 10000
    }
  }
)
