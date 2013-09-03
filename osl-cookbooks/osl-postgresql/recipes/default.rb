#
# Cookbook Name:: osl-postgresql
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'osl-postgresql::mount'
include_recipe 'postgresql::server'
include_recipe 'postgresql::config_pgtune'
include_recipe 'postgresql::contrib'
include_recipe 'firewall::postgres'

node.set['postgresql']['version'] = '9.2'
node.set['postgresql']['enable_pgdg_yum'] = true
node.set['postgresql']['dir'] = '/var/lib/pgsql/9.2/data'

node.set['postgresql']['client']['packages'] = ['postgresql92', 'postgresql92-devel']
node.set['postgresql']['server']['packages'] = ['postgresql92-server']
node.set['postgresql']['server']['service_name'] = 'postgresql-9.2'
node.set['postgresql']['contrib']['packages'] = ['postgresql92-contrib']

node.set['postgresql']['config_pgtune']['db_type'] = 'web'
node.set['postgresql']['config_pgtune']['max_connections'] = '300'

node.set['postgresql']['config']['listen_addresses'] = '*'
node.set['postgresql']['config']['log_filename'] = 'postgresql-%Y-%m-%d.log'
node.set['postgresql']['config']['wal_level'] = 'hot_standby'
node.set['postgresql']['config']['max_wal_senders'] = '10'
node.set['postgresql']['config']['archive_mode'] = 'on'
node.set['postgresql']['config']['archive_command'] = 'cp %p ../archive/%f'
