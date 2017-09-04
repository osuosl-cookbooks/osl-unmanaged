require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine_batch do
  %w(gtest2 gtest3).each do |name|
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
                        chef_version: '12.18.31'
                      }
      role 'base_managed'
      recipe 'osl-ganeti::osuosl_test'
      file('/etc/chef/encrypted_data_bag_secret',
           File.dirname(__FILE__) +
           '/encrypted_data_bag_secret')
      converge true
    end
  end
end
