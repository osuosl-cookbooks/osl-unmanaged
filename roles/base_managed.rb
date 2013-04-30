name "base_managed"
description "base role for all managed redhat systems"
run_list(
  "role[base]",
  "recipe[selinux::permissive]",
  "recipe[firewall]",
  "recipe[base::iptables]",
  "recipe[base::issue]",
  "recipe[base::users]",
  "recipe[postfix::client]",
  "recipe[firewall::nrpe]",
  "recipe[nagios::client]",
  "recipe[monitoring]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => [
        "osuadmin"
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
  "ldap" => {
    "uri" => "ldaps://ldap1.osuosl.org/ ldaps://ldap2.osuosl.org/",
    "base" => "dc=osuosl,dc=org"
  },
  "nagios" => {
    "client" => {
      "install_method" => "package"
    },
    "user" => "nrpe",
    "group" => "nrpe",
    "nrpe" => {
      "packages" => [
        "nrpe",
        "nagios-plugins",
        "nagios-plugins-disk",
        "nagios-plugins-dummy",
        "nagios-plugins-linux_raid",
        "nagios-plugins-load",
        "nagios-plugins-mailq",
        "nagios-plugins-ntp",
        "nagios-plugins-procs",
        "nagios-plugins-swap",
        "nagios-plugins-users"
      ]
    }
  }
)
