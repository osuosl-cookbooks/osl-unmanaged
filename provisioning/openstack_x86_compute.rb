require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine_batch do
  %w(otest2 otest3).each do |name|
    machine name do
      machine_options transport_options: {
        host: "#{name}.osuosl.bak",
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
                        chef_version: '13.8.5'
                      }
			attribute %w(osl-openstack credentials ceph image_token), ENV['IMAGE_TOKEN']
			attribute %w(osl-openstack credentials ceph block_token), ENV['BLOCK_TOKEN']
			attribute %w(osl-openstack credentials ceph block_backup_token), ENV['BLOCK_BACKUP_TOKEN']
      role 'base_managed'
      role 'openstack_provisioning'
      recipe 'osl-openstack::compute'
      role 'openstack_cinder'
      file('/etc/chef/encrypted_data_bag_secret',
           File.dirname(__FILE__) +
           '/encrypted_data_bag_secret')
      converge true
    end
  end
end
