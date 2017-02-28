require 'chef/provisioning'
require 'chef/provisioning/fog_driver/driver'

with_driver 'fog:OpenStack'

with_machine_options(
  bootstrap_options: {
    image_ref: '94773868-6e91-415c-9f36-df6977c43ce9', # CentOS 7.3
    flavor_ref: 'ef9144dc-11d3-4596-8d07-7f58e3530285', # m1.small
    security_groups: %w(default github),
    key_name: ENV['OS_SSH_KEYPAIR'],
    floating_ip_pool: ENV['OS_FLOATING_IP_POOL']
  },
  ssh_username: 'centos',
  convergence_options: {
    chef_version: '12.18.31'
  }
)

machine 'dns_master' do
  role 'dns'
  role 'base_managed'
  recipe 'provision_test::dns'
  recipe 'osl-dns::master'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
