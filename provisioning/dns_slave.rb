require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'dns_slave' do
  machine_options transport_options: {
    host: 'ns-slave.osuosl.org',
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
  role 'dns'
  role 'base_managed'
  recipe 'provision_test::dns'
  recipe 'osl-dns::slave'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
