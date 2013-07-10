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

# Package manager stuff
include_recipe "yum::epel"

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

# Apache
include_recipe "apache2"

case adapter
when "mysql"
  include_recipe "mysql::client"
  include_recipe "database::mysql"
when "postgresql"
  include_recipe "postgresql::client"
  include_recipe "database::postgresql"
end

# Needed for ruby gem stuff
include_recipe "build-essential"

# Needed to get from the git repo
include_recipe "git"
#case adapter
#when "mysql"
#  connection_info = {
#      :host => "mysql1-vip.osuosl.org",
#      :username => 'user',
#      :password => node['mysql']['server_root_password'].empty? ? '' : node['mysql']['server_root_password']
#  }
#when "postgresql"
#  connection_info = {
#      :host => "pg2.osuosl.org",
#      :username => 'postgres',
#      :password => node['postgresql']['password']['postgres'].empty? ? '' : node['postgresql']['password']['postgres']
#  }
#end

# Setup Apache
apache_site "000-default" do
  enable false
  notifies :restart, "service[apache2]"
end
