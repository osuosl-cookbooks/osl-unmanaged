require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

# temporary workaround for a bug with chef-provisioning
with_chef_server Chef::Config[:chef_server_url].sub('chefzero', 'http')

machine 'ajats-vpn.osuosl.org' do
  machine_options transport_options: {
    host: 'ajats-vpn.osuosl.org',
    username: 'osuadmin',
    'ssh_options' => {
      keys: [
        '/.ssh/id_rsa-bootstrap'
      ]
    },
    options: {
      prefix: 'sudo '
    }
  }
  role 'base_managed'
  role 'ajats'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
