{
  "override_attributes": {
  },
  "json_class": "Chef::Role",
  "description": "postgres server role",
  "name": "postgres",
  "chef_type": "role",
  "default_attributes": {
  },
  "run_list": [
    "role[base_managed]",
    "recipe[postgresql]",
    "recipe[firewall::postgres]"
  ],
  "env_run_lists": {
  }
}
