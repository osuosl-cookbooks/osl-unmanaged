# get the postgresql attribute information
include_attribute "postgresql"

default['postgresql']['pg_hba'] = [
  {
    :type => 'host',
    :db => 'fsslgy_redmine',
    :user => 'fsslgy_redmine',
    :addr => '140.211.15.250/32',
    :method => 'md5'
  }
]
