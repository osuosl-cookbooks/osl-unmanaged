name "base"
description "base role for all systems"
run_list(
  "recipe[base]",
  "recipe[base::environment]",
  "recipe[base::packages]",
  "recipe[networking_basic]",
  "recipe[chef-client::cron]",
  "recipe[aliases]",
  "recipe[ntp]",
  "recipe[openssh]",
  "recipe[sudo]",
  "recipe[chef-client::delete_validation]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "passwordless" => "true",
      "sudoers_defaults" => [
        "!visiblepw",
        "env_reset",
        "env_keep =  \"COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS\"",
        "env_keep += \"MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE\"",
        "env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"",
        "env_keep += \"LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE\"",
        "env_keep += \"LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY\"",
        "env_keep += \"HOME\"",
        "always_set_home",
        "secure_path = /sbin:/bin:/usr/sbin:/usr/bin"
      ]
    }
  }
)
override_attributes(
  "ntp" => {
    "servers" => [
      "time.oregonstate.edu",
      "pool.ntp.org"
    ]
  },
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
