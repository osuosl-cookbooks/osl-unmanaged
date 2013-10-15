#
# Cookbook Name:: base
# Recipe:: unmanaged
#
# Copyright 2013, OSU Open Source Lab
#

# Sudo configuration
node.default['authorization']['sudo']['users'] = ['osuadmin']
node.default['authorization']['sudo']['passwordless'] = true
node.default['authorization']['sudo']['sudoers_defaults'] = [
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

# Sysctl configuration
node.default['sysctl']['params']['kernel']['msgmnb'] = "65536"
node.default['sysctl']['params']['kernel']['msgmax'] = "65536"
node.default['sysctl']['params']['kernel']['shmmax'] = "68719476736"
node.default['sysctl']['params']['kernel']['shmall'] = "4294967296"
node.default['sysctl']['params']['net']['ipv4']['tcp_rmem'] = "4096 87380 16777216"
node.default['sysctl']['params']['net']['ipv4']['tcp_wmem'] = "4096 87380 16777216"
node.default['sysctl']['params']['net']['ipv4']['tcp_no_metrics_save'] = "1"
node.default['sysctl']['params']['net']['ipv4']['netfilter']['ip_conntrack_tcp_timeout_established'] = "14400"
node.default['sysctl']['params']['net']['core']['rmem_max'] = "16777216"
node.default['sysctl']['params']['net']['core']['wmem_max'] = "16777216"

# Postfix configuration
node.default['postfix']['mail_relay_networks'] = [
  "127.0.0.0/8",
  "10.0.0.0/23",
  "10.0.1.0/24",
  "128.193.0.128/25",
  "140.211.15.0/24",
  "140.211.18.32/27",
  "140.211.166.0/24",
  "140.211.167.0/24"
]
node.default['postfix']['mailtype'] = "client"
node.default['postfix']['mydomain'] = "osuosl.org"
node.default['postfix']['myorigin'] = "osuosl.org"
node.override['postfix']['relayhost'] = "osuosl.org"

# Disable ssh password login
node.default['openssh']['server']['password_authentication'] = "no"

# Set NTP servers
node.default['ntp']['servers'] = ['time.oregonstate.edu', 'pool.ntp.org']

# Set default mysql version
node.default['mysql']['version'] = "5.5"

# Set default ldap servers
node.override['ldap']['uri'] = "ldaps://ldap1.osuosl.org/ ldaps://ldap2.osuosl.org/"
node.override['ldap']['base'] = "dc=osuosl,dc=org"

# Rsyslog configuration
node.default['rsyslog']['server_search'] = "role:logstash_server"
node.default['rsyslog']['port'] = "5000"
node.default['rsyslog']['preserve_fqdn'] = "on"

# Nagios backend IP configuration
mon_host = ['127.0.0.1']
unless Chef::Config[:solo]
  search(:node, "roles:#{node['nagios']['server_role']}") do |node|
    node["network"]["interfaces"].collect { |i| i[1]["addresses"].select{ |address, data| data["family"] == "inet" }.keys }.flatten.each do |ipaddress|
      mon_host << ipaddress
    end
  end
end
node.default['nagios']['allowed_hosts'] = mon_host.uniq


# Include the base_managed recipes
include_recipe "base::unmanaged"
unless Chef::Config[:solo]
  include_recipe "firewall"
end
include_recipe "base::security"
unless Chef::Config[:solo]
  include_recipe "base::iptables"
end
include_recipe "base::issue"
include_recipe "base::users"
include_recipe "base::ifconfig"
include_recipe "postfix::client"
unless Chef::Config[:solo]
  include_recipe "firewall::nrpe"
  include_recipe "nagios::client"
end
include_recipe "ntp"
include_recipe "sudo"
unless Chef::Config[:solo]
  include_recipe "monitoring"
end
include_recipe "sysctl"
unless Chef::Config[:solo]
  include_recipe "rsyslog::client"
end
