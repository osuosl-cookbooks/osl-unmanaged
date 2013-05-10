#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['goblin']['db_password'] = secure_password

application "goblin" do
  path "/srv/goblin"
  owner "goblin"
  group "goblin"
  repository "https://github.com/osuosl/Goblin.git"
  revision "master"
  migrate true
  packages ["libpq-dev", "git-core"]

  django do
    packages ["redis"]
    requirements "requirements/requirements.txt"
    settings_template "settings.py.erb"
    debug true
    collectstatic "build_static --noinput"
    database do
      database "goblin"
      engine "postgresql_psycopg2"
      username "goblin"
      password node['goblin']['db_password']
    end
    database_master_role "goblin_database_master"
  end
end

