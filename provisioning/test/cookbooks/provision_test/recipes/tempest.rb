include_recipe 'openstack-integration-test::setup'

edit_resource(:python_runtime, '2') do
  provider :system
  pip_version '9.0.3'
end

edit_resource(:python_virtualenv, '/opt/tempest-venv') do
  system_site_packages true
  pip_version '9.0.3'
end

execute 'Add network uuid' do
  command <<-EOF
    NET_ID=$(cat /var/tmp/public_network)
    sed -i -e "s/SET_NET_ID/${NET_ID}/g" /opt/tempest/etc/tempest.conf
  EOF
end
