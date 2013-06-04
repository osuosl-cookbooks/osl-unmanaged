#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

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

template "/var/www/goblin/current/etc/logging.conf" do
  source "logging.conf.erb"
  mode 00644
  owner "root"
  group "www-data"
end
