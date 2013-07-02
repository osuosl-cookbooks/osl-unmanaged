name "postgres"
description "postgresql server role"
run_list(
    "role[base_managed]",
    "recipe[postgresql::server]",
    "recipe[firewall::postgres]"
)
default_attributes(
)
override_attributes(
  "postgresql" => {
    "version" => "9.2",
    "config" => {
      "listen_addresses" => "*",
      "max_connections" => "600",
      "shared_buffers" => "1024MB",
      "log_filename" => "postgresql-%Y-%m-%d.log"
    }
  }
)
