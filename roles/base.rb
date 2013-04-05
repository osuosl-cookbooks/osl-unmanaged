name "base"
description "base role for all systems"
run_list(
  "recipe[base]",
  "recipe[yum::yum]",
  "recipe[yum::epel]",
  "recipe[base::oslrepo]",
  "recipe[chef-client]",
  "recipe[firewall]",
  "recipe[base::iptables]",
  "recipe[base::packages]",
  "recipe[base::users]",
  "recipe[networking_basic]",
  "recipe[aliases]",
  "recipe[ntp]",
  "recipe[postfix::client]",
  "recipe[openssh]",
  "recipe[sudo]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => [
        "osuadmin",
        "vagrant"
      ],
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
  "postfix" => {
    "mail_relay_networks" => 
      "127.0.0.0/8, 10.0.0.0/23, 10.0.1.0/24, 
       128.193.0.128/25, 140.211.15.0/24,
       140.211.18.32/27, 140.211.166.0/24,
       140.211.167.0/24",
    "mailtype"            => "client",
    "mydomain"            => "osuosl.org",
    "myorigin"            => "osuosl.org",
    "relayhost"           => "osuosl.org"
  },
  "ntp" => {
    "servers" => [
      "time.oregonstate.edu",
      "pool.ntp.org"
    ]
  },
  "openssh" => {
    "server" => {
      "password_authentication" => "no"
    }
  }
)
