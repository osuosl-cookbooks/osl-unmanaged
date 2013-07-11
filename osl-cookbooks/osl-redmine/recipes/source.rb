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
# http://www.apache.org/licenses/LICENSE-2.0
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

# All the required recipes for this
include_recipe "yum::epel"
include_recipe "apache2"
include_recipe "git"
include_recipe "build-essential" # needed for ruby gems building
case adapter # use  a db reciped depending on the desired db
when "mysql"
  include_recipe "mysql::client"
  include_recipe "database::mysql"
when "postgresql"
  include_recipe "postgresql::client"
  include_recipe "database::postgresql"
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


#case adapter
#when "mysql" # These should be overridden in editing the node!
#  connection_info = {
#      :host => "localhost",
#      :username => 'root',
#      :password => node['mysql']['server_root_password'].empty? ? '' : node['mysql']['server_root_password']
#  }
#when "postgresql"
#  connection_info = {
#      :host => "localhost",
#      :username => 'postgres',
#      :password => node['postgresql']['password']['postgres'].empty? ? '' : node['postgresql']['password']['postgres']
#  }
#end

# Setup DB User

# Setup DB User Permissions

# Setup Apache
apache_site "000-default" do
  enable false
  notifies :restart, "service[apache2]"
end

web_app "redmine" do
  docroot ::File.join(node['redmine']['path'], 'public')
  template "redmine.conf.erb"
  server_name "redmine.#{node['domain']}"
  server_aliases [ "redmine", node['hostname'] ]
  rails_env environment
end


# Install Bundler
gem_package "bundler" do
  action :install
end
