{
  "name": "phpbb_lb",
  "description": "phpbb load balancer",
  "json_class": "Chef::Role",
  "chef_type": "role",
  "run_list": [
    "role[base_managed]",
    "recipe[phpbb::haproxy]"
  ]
}
