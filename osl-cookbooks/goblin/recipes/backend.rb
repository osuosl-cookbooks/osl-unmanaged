#
# Cookbook Name:: goblin
# Recipe:: backend
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "postgresql::server"
include_recipe "rabbitmq"
include_recipe "goblin::default"

# Allow PostgreSQL
simple_iptables_rule "postgres" do
  rule "--proto tcp --dport 5432"
  jump "ACCEPT"
end

# Allow RabbitMQ
simple_iptables_rule "rabbitmq" do
  rule "--proto tcp --dport 5672"
  jump "ACCEPT"
end
rabbitmq_vhost "/optin" do
  action :add
end

rabbitmq_user "optin" do
  vhost "/optin"
  password "CbXVtHJHFmwgE"
  action [:add]
end
rabbitmq_user "optin" do
  permissions ".* .* .*"
  action [:set_permissions]
end
rabbitmq_user "optin" do
  tag "goblin"
  action [:set_tags]
end

node.default['postgresql']['config']['listen_addresses'] = '*'
node.default['postgresql']['pg_hba'] = {
      :comment => "Goblin user",
      :type => "host",
      :db => "all",
      :user => "goblin",
      :addr => "128.192.4.0/24",
      :method => "md5"
    }

