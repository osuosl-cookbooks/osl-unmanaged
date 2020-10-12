include_recipe 'openstack-integration-test::setup'

execute 'Add network uuid' do
  command <<-EOF
    NET_ID=$(cat /var/tmp/public_network)
    sed -i -e "s/SET_NET_ID/${NET_ID}/g" /opt/tempest/etc/tempest.conf
  EOF
end
