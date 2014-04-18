base_path   = File.expand_path(File.join(File.dirname(__FILE__), ".."))
user_email  = `git config --get user.email`
home_dir    = ENV['HOME'] || ENV['HOMEDRIVE']
org         = ENV['chef_org'] || 'my_org'

chef_server_url         'https://chef.osuosl.org'
log_level               :info
log_location            STDOUT

# USERNAME is UPPERCASE in Windows, but lowercase in the Chef server,
# so `downcase` it.
node_name               ( ENV['KNIFE_USER'] || ENV['USER'] || ENV['USERNAME'] ).downcase
client_key              "#{home_dir}/.chef/#{node_name}.pem"
validation_client_name  'chef-validator'
validation_key          "#{home_dir}/.chef/#{validation_client_name}.pem"
cache_type              'BasicFile'
cache_options( :path => "#{home_dir}/.chef/checksums" )
cookbook_path [
                        "#{base_path}/osuosl-cookbooks",
                        "#{base_path}/community-cookbooks"
              ]
cookbook_copyright      "Oregon State University"
cookbook_license        "apachev2"
cookbook_email          "systems@osuosl.org"
role_path               ["#{base_path}/roles"]
data_bag_path           ["#{base_path}/data_bags"]
encrypted_data_bag_secret =  "#{home_dir}/.chef/encrypted_data_bag_secret"
#knife[:secret_file] =  "#{home_dir}/.chef/encrypted_data_bag_secret"
ssl_verify_mode         :verify_peer
