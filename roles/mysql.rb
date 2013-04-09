name "mysql"
description "mysql server role"
run_list(
  "role[base]",
  "recipe[firewall::mysql]",
  "recipe[base::mysql]",
  "recipe[mysql::server]"
)
default_attributes(
)
override_attributes(
  "mysql" => {
    "server" => {
      "packages" => [
        "Percona-Server-shared-55",
        "Percona-Server-server-55",
        "percona-toolkit",
        "percona-xtrabackup"
      ]
    },
    "client" => {
      "packages" => [
        "Percona-Server-client-55",
        "Percona-Server-shared-compat"
      ]
    },
    "service_name" => "mysql"
  }
)
