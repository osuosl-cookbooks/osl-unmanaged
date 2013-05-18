#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "goblin"

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
      database "goblin"
      engine "sqlite3"
    end
    #database_master_role "goblin_database_master"
  end
end

git "/var/www/goblin/shared/env/lib/python2.6/site-packages/googleimap" do
  repository "git://github.com/osuosl/google-imap.git"
  reference "master"
  action :sync
end

