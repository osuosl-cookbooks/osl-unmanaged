#
# Cookbook Name:: osl-slapd
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Create the user and group before the package is installed
group "ldap" do
  action :create
  gid 401
end

user "ldap" do
  action :create
  uid 401
  gid "ldap"
  home "/var/lib/ldap"
  shell "/sbin/nologin"
end

# Create these directories before the package, and we avoid the slapd.d config
# issues with the newer RTC OpenLDAP configuration.
%w{/ certs schema slapd.d}.each do |confdir|
  directory "#{node['osl-slapd']['dir']}/#{confdir}" do
    action :create
    owner "ldap"
    group "ldap"
    mode "00700"
  end
end

directory "/var/lib/ldap" do
  owner "ldap"
  group "ldap"
  recursive true
  mode 00700
end

cookbook_file "/var/lib/ldap/DB_CONFIG" do
  source "DB_CONFIG"
  owner "ldap"
  group "ldap"
  mode 00600
end

cookbook_file "/etc/sysconfig/ldap" do
  source "ldap"
  owner "root"
  group "root"
  mode 00644
end

# Deploy ldap certificates
certificate_manage "ldap" do
  cert_path "/etc/openldap/certs"
  owner "ldap"
  group "ldap"
  create_subfolders false
  cert_file "ldap.pem"
  key_file "ldap.key"
  chain_file "ldap-bundle.crt"
end

# Copy over our custom schemas
%w{ldapns.schema openssh-lpk.schema samba.schema}.each do |schema|
  cookbook_file "#{node['osl-slapd']['dir']}/schema/#{schema}" do
    source schema
    mode 00644
  end
end

execute "slapd-config-convert" do
  command "slaptest -f #{node['osl-slapd']['dir']}/slapd.conf -F #{node['osl-slapd']['dir']}/slapd.d/"
  user "ldap"
  action :nothing
  only_if "test -f /usr/sbin/slaptest && test -f #{node['osl-slapd']['dir']}/slapd.conf"
end

template "#{node['osl-slapd']['dir']}/slapd.conf" do
  source "slapd.conf.erb"
  mode 00640
  owner "ldap"
  group "ldap"
  notifies :run, resources(:execute => "slapd-config-convert"), :delayed
end

# Initial configuration is done, install the package and start the service
package "openldap-servers" do
  action :install
  # We re-create the slapd.conf here because the initial install will read
  # slapd.conf and rename it to slapd.conf.bak after converting the
  # configuration to the newer slapd.d format
  notifies :create, resources(:template => "#{node['osl-slapd']['dir']}/slapd.conf")
end

service "slapd" do
  action [:enable, :start]
end
