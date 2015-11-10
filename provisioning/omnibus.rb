require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

# temporary workaround for a bug with chef-provisioning
with_chef_server Chef::Config[:chef_server_url].sub('chefzero', 'http')

machine_batch do
  action [:ready, :converge_only]
#  action :converge
#  action :destroy
  machine 'omnibus-ppc64' do
    machine_options transport_options: {
      host: '140.211.168.45',
      username: 'rhel',
      'ssh_options' => {
        keys: [
          '~/.ssh/id_rsa-work'
        ]
      },
      options: {
        prefix: 'sudo '
      }
    }
    recipe 'omnibus'
    file('/etc/chef/encrypted_data_bag_secret',
         File.dirname(__FILE__) +
         '/encrypted_data_bag_secret')
  end

  machine 'omnibus-ppc64le' do
    machine_options transport_options: {
      host: '140.211.168.46',
      username: 'rhel',
      'ssh_options' => {
        keys: [
          '~/.ssh/id_rsa-work'
        ]
      },
      options: {
        prefix: 'sudo '
      }
    }
    recipe 'omnibus'
    file('/etc/chef/encrypted_data_bag_secret',
         File.dirname(__FILE__) +
         '/encrypted_data_bag_secret')
  end
end
