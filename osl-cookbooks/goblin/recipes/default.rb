#
# Cookbook Name:: goblin
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "simple_iptables"
include_recipe "perl"

directory "/var/www/goblin/shared/env/lib/python2.6/site-packages/googleimap" do
   owner "root"
   group "www-data"
   recursive true
   mode 0755
end

directory "/var/www/goblin/shared" do
   mode 0775
   recursive true
end

file "/var/www/goblin/shared/celeryd@celery.pid" do
   mode "0775"
end

%w{git moreutils libconfig-simple-perl libcyrus-imap-perl22 libsasl2-dev libldap2-dev python2.6-dev ldap-utils libnet-oauth-perl libmail-imapclient-perl}.each do |pkg|
  package pkg
end

git "/var/www/goblin/shared/env/lib/python2.6/site-packages/googleimap" do
  repository "git://github.com/osuosl/google-imap.git"
  reference "master"
  action :sync
end

# URI::Escape is not packaged in Debian
cpan_module "URI::Escape"

# Clone google-imap scripts
git "/opt/google-imap" do
  repository "git://github.com/osuosl/google-imap.git"
  reference "master"
  action :sync
end

user_account 'optin' do
   system_user true
   home    '/none'
   shell   '/bin/false'
end

group "www-data" do
  action :modify
  members "optin"
  append true
end

