require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine_batch do
  action [:ready, :converge_only]
  #  action :converge
  #  action :destroy
  machine 'omnibus-ppc64' do
    machine_options transport_options: {
      host: '10.1.100.54',
      username: 'centos',
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
      host: '10.1.100.55',
      username: 'centos',
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
