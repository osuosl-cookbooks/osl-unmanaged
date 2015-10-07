require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

# temporary workaround for a bug with chef-provisioning
with_chef_server Chef::Config[:chef_server_url].sub('chefzero', 'http')

machine 'controller' do
  machine_options transport_options: {
    host: 'otest-controller.osuosl.org',
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
                    install_sh_arguments: '-f /tmp/chef.rpm'
                  }
  role 'base_managed'
  role 'openstack_provisioning'
  recipe 'osl-openstack::ops_database'
  recipe 'osl-openstack::controller'
  recipe 'openstack-integration-test::setup'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end

machine_batch do
  %w(otest2 otest3).each do |name|
    machine name do
      machine_options transport_options: {
        host: "#{name}.osuosl.bak",
        username: 'root',
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
                        install_sh_arguments: '-f /tmp/chef.rpm'
                      }
      role 'base_managed'
      role 'openstack_provisioning'
      recipe 'osl-openstack::compute'
      file('/etc/chef/encrypted_data_bag_secret',
           File.dirname(__FILE__) +
           '/encrypted_data_bag_secret')
      converge true
    end
  end
end
