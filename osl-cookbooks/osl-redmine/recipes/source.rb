# Cookbook Name:: redmine
# Recipe:: source
#
# Copyright 2012, Juanje Ojeda <juanje.ojeda@gmail.com>
# Copyright 2013, Roberto Majadas <roberto.majadas@openshine.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Some handy vars
environment = node['redmine']['env']
adapter = node["redmine"]["databases"][environment]["adapter"]

#Setup system package manager
case node['platform']
when "debian","ubuntu"
  include_recipe "apt"
when "redhat","centos","amazon","scientific","fedora","suse"
  include_recipe "yum::epel"
end

#Install redmine required dependencies
node['redmine']['packages']['ruby'].each do |pkg|
  package pkg
end
node['redmine']['packages']['apache'].each do |pkg|
  package pkg
end

if node['redmine']['install_rmagick']
  node['redmine']['packages']['rmagick'].each do |pkg|
    package pkg
  end
end

#Setup database
node['redmine']['packages'][adapter].each do |pkg|
  package pkg
end
case adapter
when "mysql"
  include_recipe "mysql::client"
when "postgresql"
  include_recipe "postgresql::client"
end

#Setup Apache
include_recipe "apache2"
apache_site "000-default" do
  enable false
  notifies :restart, "service[apache2]"
end

web_app "redmine" do
  docroot        ::File.join(node['redmine']['path'], 'public')
  template       "redmine.conf.erb"
  server_name    "#{node['fqdn']}"
  server_aliases [ "redmine", node['hostname'] ]
  rails_env      environment
end

#Install Bundler
if platform?("debian","ubuntu")
  if node['platform_version'].to_f < 10.10
    %w{libopenssl-ruby rake}.each do |package_name|
      package package_name do
        action :install
      end
    end
    gem_package "rubygems-update" do
      action :install
    end
    execute "update rubygems" do
      command '/var/lib/gems/1.8/bin/update_rubygems'
    end
    execute "install bundler" do
      command 'gem install bundler'
    end
  else
    gem_package "bundler" do
      action :install
    end
  end
else
  gem_package "bundler" do
    action :install
  end
end

# deploy the Redmine app
include_recipe "git"
deploy_revision node['redmine']['deploy_to'] do
  repo     node['redmine']['repo']
  revision node['redmine']['revision']
  user     node['apache']['user']
  group    node['apache']['group']
  environment "RAILS_ENV" => environment
  #shallow_clone true

  before_migrate do
    %w{config log system pids}.each do |dir|
      directory "#{node['redmine']['deploy_to']}/shared/#{dir}" do
        owner node['apache']['user']
        group node['apache']['group']
        mode '0755'
        recursive true
      end
    end

    template "#{node['redmine']['deploy_to']}/shared/config/database.yml" do
      source "database.yml.erb"
      owner node['apache']['user']
      group node['apache']['group']
      mode "644"
      variables(
        :host => node['redmine']['databases'][environment]['host'],
        :db   => node['redmine']['databases'][environment],
        :rails_env => environment
      )
    end

    case adapter
    when "mysql"
      gem_package "mysql" do
        version "~> 2.8.1"
        action :install
      end
      execute "bundle install --without development test postgresql sqlite" do
        cwd release_path
      end
    when "postgresql"
      gem_package "pg" do
        version ">= 0.11.0"
        action :install
      end
      execute "bundle install --without development test mysql sqlite" do
        cwd release_path
      end
    end

    if Gem::Version.new(node['redmine']['revision']) < Gem::Version.new('2.0.0')
      execute 'rake generate_session_store' do
        cwd release_path
        not_if { ::File.exists?("#{release_path}/db/schema.rb") }
      end
    else
      execute 'rake generate_secret_token' do
        cwd release_path
        not_if { ::File.exists?("#{release_path}/config/initializers/secret_token.rb") }
      end
    end

  end

  migrate true
  migration_command 'rake db:migrate'

  create_dirs_before_symlink %w{tmp public config tmp/pdf public/plugin_assets}

  before_restart do
    link node['redmine']['path'] do
      to release_path
    end
  end

  action :deploy
  notifies :restart, "service[apache2]"
end
