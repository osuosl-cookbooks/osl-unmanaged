name "mysql"
description "mysql server role"
run_list(
  "recipe[mysql::percona_repo]",
  "recipe[mysql::server]",
  "role[base]",
  "recipe[firewall::mysql]",
  "recipe[base::mysql]",
  "recipe[monitoring::mysql]"
)
default_attributes(
)
override_attributes(
  "mysql" => {
    "version" => "5.5",
    "service_name" => "mysql",
    "bind_address" => "0.0.0.0",
    "old_passwords" => "0",
    "root_network_acl" => "localhost",
    "remove_anonymouse_users" => true,
    "allow_remote_root" => false,
    "remove_test_database" => true,
    "tunable" => {
      "key_buffer_size" => "32M",
      "myisam_recover" => "FORCE,BACKUP",
      "max_allowed_packet" => "128M",
      "max_connect_errors" => "100000",
      "log_bin" => "/var/lib/mysql/mysql-bin",
      "expire_logs_days" => "10",
      "sync_binlog" => "0",
      "query_cache_type" => "0",
      "query_cache_size" => "0",
      "max_connections" => "500",
      "thread_cache_size" => "50",
      "open_files_limit" => "65535",
      "table_definition_cache" => "4096",
      "table_open_cache" => "10240",
      "innodb_flush_method" => "O_DIRECT",
      "innodb_log_files_in_group" => "2",
      "innodb_log_file_size" => "512M",
      "innodb_flush_log_at_trx_commit" => "2",
      "innodb_file_per_table" => "1",
      "connect_timeout" => "28880",
    },
  },
  "nagios" => {
    "nrpe" => {
      "packages" => [
        "percona-nagios-plugins"
      ]
    }
  }
)
