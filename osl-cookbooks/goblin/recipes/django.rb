#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Django goblin application is installed by default on all nodes.
case node['hostname'] 
  when "mig-fe1","mig-fe2","mig-w1","mig-w2","mig-w3"
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
        collectstatic true
        database do
          database "django"
          host "mig-be.onid.oregonstate.edu"
          engine "postgresql_psycopg2"
          username "goblin"
          password Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinpg"]
        end
      end
    end
  else
    application "goblin" do
      path "/var/www/goblin"
      owner "root"
      group "www-data"
      repository "https://github.com/osuosl/Goblin.git"
      revision "bug/13713_prsync_check"
      #revision "master"
      migrate true
      packages ["libpq-dev", "git-core", "libsasl2-dev", "libldap2-dev",
        "python2.6-dev", "libapache2-mod-auth-cas"]

      django do
        requirements "requirements/requirements.txt"
        settings_template "settings.py.erb"
        debug true
        collectstatic true
        database do
          database "django"
          host "test-migbe.onid.oregonstate.edu"
          engine "postgresql_psycopg2"
          username "goblin"
          password Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinpg"]
        end
      end
    end
end

template "/var/www/goblin/current/etc/opt-in.properties" do
  source "opt-in.properties.erb"
  mode 00644
  owner "root"
  group "www-data"
end

template "/var/www/goblin/current/celeryconfig.py" do
  source "celeryconfig.py.erb"
  mode 00644
  owner "root"
  group "www-data"
end

