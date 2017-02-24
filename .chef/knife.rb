base_path   = File.expand_path(File.join(File.dirname(__FILE__), ".."))
user_email  = `git config --get user.email`
home_dir    = ENV['HOME'] || ENV['HOMEDRIVE']
knife[:secret_file] = "#{home_dir}/.chef/encrypted_data_bag_secret"

chef_server_url         'https://chef.osuosl.org/organizations/osuosl'

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
              ]
cookbook_copyright      "Oregon State University"
cookbook_license        "apachev2"
cookbook_email          "systems@osuosl.org"
role_path               ["#{base_path}/roles"]
data_bag_path           ["#{base_path}/data_bags"]
data_bag_encrypt_version 2
ssl_verify_mode         :verify_peer
