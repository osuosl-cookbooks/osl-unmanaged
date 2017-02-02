require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'openstack_haproxy' do
  machine_options transport_options: {
    host: 'lb-openstack.osuosl.org',
    username: 'osuadmin',
    'ssh_options' => {
      keys: [
        '~/.ssh/id_rsa-bootstrap'
      ]
    },
    options: {
      prefix: 'sudo '
    }
  },
                  convergence_options: {
                    chef_version: '12.18.31'
                  }
  role 'base_managed'
  recipe 'firewall::openstack'
  recipe 'osl-openstack::haproxy'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
