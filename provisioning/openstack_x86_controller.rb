require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'controller' do
  machine_options transport_options: {
    host: 'otest-controller.osuosl.org',
    username: 'osuadmin',
    'ssh_options' => {
      keys: [
        '~/.ssh/id_rsa-bootstrap',
      ],
    },
    options: {
      prefix: 'sudo ',
    },
  },
                  convergence_options: {
                    chef_version: '13.8.5',
                  }
  attribute %w(osl-openstack node_type), 'controller'
  role 'base_managed'
  role 'ceph'
  role 'ceph_mon'
  role 'ceph_mgr'
  role 'ceph_osd'
  role 'ceph_setup'
  role 'openstack_provisioning'
  recipe 'osl-openstack::ops_database'
  recipe 'osl-openstack::controller'
  role 'openstack_cinder'
  recipe 'provision_test::orchestration'
  recipe 'provision_test::tempest_x86'
  recipe 'provision_test::tempest'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
