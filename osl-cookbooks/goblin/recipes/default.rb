#
# Cookbook Name:: goblin
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "simple_iptables"


# Django goblin application is installed by default on all nodes.
application "goblin" do
  path "/var/www/goblin"
  owner "root"
  group "www-data"
  repository "https://github.com/osuosl/Goblin.git"
  revision "master"
  migrate true
  packages ["libpq-dev", "git-core", "libsasl2-dev", "libldap2-dev",
    "python2.6-dev", "libapache2-mod-auth-cas"]

  django do
    requirements "requirements/requirements.txt"
    settings_template "settings.py.erb"
    debug true
    database do
      database "django"
      engine "postgresql_psycopg2"
      username "goblin"
      password Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinpg"]
    end
    database_master_role "goblin_backend"
  end
end

git "/var/www/goblin/shared/env/lib/python2.6/site-packages/googleimap" do
  repository "git://github.com/osuosl/google-imap.git"
  reference "master"
  action :sync
end

%w{moreutils libsasl2-dev libldap2-dev python2.6-dev ldap-utils libnet-oauth-perl libmail-imapclient-perl}.each do |pkg|
  package pkg
end

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

