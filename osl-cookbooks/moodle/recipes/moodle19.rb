include_recipe "mysql::percona_repo"
include_recipe "mysql::ruby"
include_recipe "php::module_mysql"

%w[
  git
].each{|p| package(p) }

### Local vars ###
moodle_version = '1.9.19'
moodle_dir = "moodle-#{moodle_version}"

## Prepare
mysql_database node.moodle['database'] do
  connection :host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']
  encoding 'UTF8'
  action :create
end

directory node['moodle']['data_dir'] do
  owner 'apache'
  group 'apache'
  mode 0777
end

git "/var/www/html" do
    repository 'git://git.moodle.org/moodle.git'
    revision 'MOODLE_19_STABLE' 
    action :checkout
end

apache_site 'default' do
  enable false
end

web_app 'moodle' do
  template 'moodle.conf.erb'
end