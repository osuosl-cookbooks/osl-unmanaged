name "base_managed"
description "base role for all managed systems"
run_list(
  "role[base]",
  "recipe[firewall]",
  "recipe[base::iptables]",
  "recipe[base::issue]",
  "recipe[base::users]",
  "recipe[base::ifconfig]",
  "recipe[postfix::client]",
  "recipe[firewall::nrpe]",
  "recipe[nagios::client]",
  "recipe[ntp]",
  "recipe[sudo]",
  "recipe[monitoring]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => [
        "osuadmin"
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
    "mail_relay_networks" => [
      "127.0.0.0/8",
      "10.0.0.0/23",
      "10.0.1.0/24",
      "128.193.0.128/25",
      "140.211.15.0/24",
      "140.211.18.32/27",
      "140.211.166.0/24",
      "140.211.167.0/24"
    ],
    "mailtype"  => "client",
    "mydomain"  => "osuosl.org",
    "myorigin"  => "osuosl.org",
    "relayhost" => "osuosl.org"
  },
  "openssh" => {
    "server" => {
      "password_authentication" => "no"
    }
  },
  "ntp" => {
    "servers" => [
      "time.oregonstate.edu",
      "pool.ntp.org"
    ]
  },
  "ldap" => {
    "uri" => "ldaps://ldap1.osuosl.org/ ldaps://ldap2.osuosl.org/",
    "base" => "dc=osuosl,dc=org"
  }
)
