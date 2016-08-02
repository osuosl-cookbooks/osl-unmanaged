require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'controller_openpower' do
  machine_options transport_options: {
    host: 'otest-openpower-controller.osuosl.org',
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
                    chef_version: '12.10.24'
                  }
  role 'base_managed'
  role 'openstack_provisioning_ppc64'
  recipe 'osl-openstack::ops_database'
  recipe 'osl-openstack::controller'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
