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
                    chef_version: '12.18.31'
                  }
  attribute %w(osl-openstack node_type), 'controller'
  attribute %w(osl-openstack credentials image_token), ENV['IMAGE_TOKEN']
  attribute %w(osl-openstack credentials block_token), ENV['BLOCK_TOKEN']
  attribute %w(osl-openstack credentials block_backup_token), ENV['BLOCK_BACKUP_TOKEN']
  role 'base_managed'
  role 'openstack_provisioning_ppc64'
  recipe 'osl-openstack::ops_database'
  recipe 'osl-openstack::controller'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
