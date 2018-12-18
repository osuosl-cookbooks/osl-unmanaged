require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'openpower8' do
  machine_options transport_options: {
    host: 'openpower8.osuosl.bak',
    username: 'root',
    'ssh_options' => {
      keys: [
        '~/.ssh/id_rsa-bootstrap',
      ],
    },
  },
                  convergence_options: {
                    chef_version: '13.8.5',
                  }
  role 'base_managed'
  role 'openstack_provisioning_ppc64'
  recipe 'osl-openstack::compute'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
