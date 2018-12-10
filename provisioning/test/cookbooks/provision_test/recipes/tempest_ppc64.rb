execute 'create public network' do
  command <<-EOF
    source /root/openrc
    openstack network create --share --provider-network-type=flat --provider-physical-network=public \
      --external --default public
    openstack subnet create public --network public --subnet-range=140.211.169.128/26 \
      --allocation-pool=start=140.211.169.160,end=140.211.169.180 --dns-nameserver 140.211.166.130 \
      --dns-nameserver 140.211.166.131 --gateway 140.211.169.129
      openstack network show -c id -f value public > /var/tmp/public_network
  EOF
  creates '/var/tmp/public_network'
end

cirros_source = 'http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-ppc64le-disk.img'

node.default['openstack']['integration-test']['image1']['source'] = cirros_source
node.default['openstack']['integration-test']['image2']['source'] = cirros_source

node.default['openstack']['integration-test']['conf'].tap do |conf|
  conf['compute-feature-enabled']['block_migration_for_live_migration'] = true
  conf['compute-feature-enabled']['live_migrate_back_and_forth'] = true
  conf['compute-feature-enabled']['metadata_service'] = false
  conf['compute-feature-enabled']['volume_backed_live_migration'] = true
  conf['compute']['live_migration_available'] = true
  conf['compute']['use_block_migration_for_live_migration'] = true
  conf['network']['public_network_id'] = 'SET_NET_ID'
  conf['service_available']['cinder'] = true
  conf['service_available']['neutron'] = true
  conf['volume']['backup'] = true
  conf['volume']['catalog_type'] = 'volumev2'
  conf['volume-feature-enabled']['extend_attached_volume'] = true
  conf['volume-feature-enabled']['manage_snapshot'] = true
  conf['volume-feature-enabled']['manage_volume'] = true
  conf['volume-feature-enabled']['snapshot'] = true
end
