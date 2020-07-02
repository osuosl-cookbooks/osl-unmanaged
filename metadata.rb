name             'chef-repo'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache 2.0'
version          '0.0.1'

# Pull metadata cookbooks and versions directly from our environment file
require 'json'
env = ENV['CHEF_ENVIRONMENT'] || 'production'
env_dir = ENV['CHEF_ENV_DIR'] || 'environments'
env_file = File.read("#{env_dir}/#{env}.json")
environment = JSON.parse(env_file)
environment['cookbook_versions'].each do |cb, ver|
  depends cb, ver
end

supports         'centos', '~> 6.0'
supports         'centos', '~> 7.0'
supports         'debian'
