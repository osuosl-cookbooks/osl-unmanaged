require 'chef/provisioning'

with_driver 'fog:OpenStack'

with_machine_options(
  bootstrap_options: {
    image_ref: '94773868-6e91-415c-9f36-df6977c43ce9', # CentOS 7.3
    flavor_ref: '3', # m1.medium
    security_groups: %w(default github),
    key_name: ENV['OS_SSH_KEYPAIR'],
    floating_ip_pool: ENV['OS_FLOATING_IP_POOL']
  },
  ssh_username: 'centos',
  convergence_options: {
    chef_version: '12.18.31'
  }
)

machine 'dns_jenkins' do
  attribute %w(osl-jenkins credentials git bumpzone user), ENV['GITHUB_USER']
  attribute %w(osl-jenkins credentials git bumpzone token), ENV['GITHUB_TOKEN']
  attribute %w(osl-jenkins credentials jenkins bumpzone user), ENV['JENKINS_USER']
  attribute %w(osl-jenkins credentials jenkins bumpzone api_token), ENV['JENKINS_PASS']
  attribute %w(osl-jenkins credentials jenkins bumpzone trigger_token), ENV['TRIGGER_TOKEN']
  role 'dns'
  role 'base_managed'
  recipe 'provision_test::dns'
  recipe 'osl-jenkins::bumpzone'
  file('/etc/chef/encrypted_data_bag_secret',
       File.dirname(__FILE__) +
       '/encrypted_data_bag_secret')
  converge true
end
