name "base_ubuntu"
description "base role for all ubuntu systems"
run_list(
  "recipe[base]",
  "recipe[apt]",
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
        "osuadmin"
      ],
      "passwordless" => "true",
      "sudoers_defaults" => [
        'env_reset',
        'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
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
