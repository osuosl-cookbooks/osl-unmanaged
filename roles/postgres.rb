name "postgres"
description "postgresql server role"
run_list(
    "role[base_managed]",
    "recipe[postgresql::server]",
    "recipe[postgresql::config_pgtune]",
    "recipe[firewall::postgres]"
)
default_attributes(
)
override_attributes(
  "postgresql" => {
    "version" => "9.2",
    "enable_pgdg_yum" => true,
    "dir" => "/var/lib/pgsql/9.2/data",
    "client" => {
      "packages" => ["postgresql92", "postgresql92-devel"]
    },
    "server" => {
      "packages" => ["postgresql92-server"],
      "service_name" => "postgresql-9.2"
    },
    "contrib" => {
      "packages" => ["postgresql92-contrib"]
    },
    "config_pgtune" => {
      "db_type" => "web",
      "max_connections" => "300",
    },
    "config" => {
      "listen_addresses" => "*",
      "max_connections" => "600",
      "shared_buffers" => "1024MB",
      "log_filename" => "postgresql-%Y-%m-%d.log"
    }
  }
)
