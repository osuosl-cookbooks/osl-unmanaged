name "base"
description "base role for all systems"
run_list(
  "recipe[base]",
  "recipe[base::environment]",
  "recipe[base::packages]",
  "recipe[networking_basic]",
  "recipe[chef-client::cron]",
  "recipe[aliases]",
  "recipe[openssh]",
  "recipe[chef-client::delete_validation]"
)
default_attributes(
)
override_attributes(
  "chef_client" => {
    "init_style" => "none",
    "cron" => {
      "minute" => "*/30",
      "hour" => "*",
      "use_cron_d" => "true",
      "log_file" => "/var/log/chef/client.log"
    }
  }
)
