require 'chef/provisioning'
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

machine 'op-ceph1' do
  machine_options transport_options: {
    host: 'op-ceph1.osuosl.bak',
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
  role 'base_managed'
  recipe 'provision_test::ceph'
  role 'ceph_ppc64'
  role 'ceph_mon_ppc64'
  role 'ceph_mgr_ppc64'
  role 'ceph_osd_ppc64'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end

machine_batch do
  (2..5).to_a.each do |i|
    machine "op-ceph#{i}" do
      machine_options transport_options: {
        host: "op-ceph#{i}.osuosl.bak",
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
      role 'base_managed'
      recipe 'provision_test::ceph'
      role 'ceph_ppc64'
      role 'ceph_mon_ppc64'
      role 'ceph_mgr_ppc64'
      role 'ceph_osd_ppc64'
      file('/etc/chef/encrypted_data_bag_secret',
           File.dirname(__FILE__) +
           '/encrypted_data_bag_secret')
      converge true
    end
  end
end
