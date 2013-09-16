{
  "name": "phpbb_lb",
  "description": "phpbb load balancer",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[base_managed]",
    "recipe[phpbb::haproxy]"
  ],
  "env_run_lists": {
  }
}
