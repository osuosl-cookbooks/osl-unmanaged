name "phpbb_www"
description "phpbb web node"
run_list(
  "role[base_managed]",
  "recipe[phpbb::apache]",
  "recipe[phpbb::memcache]"
) 
override_attributes(
  "memcached" => {
    "memory" => "64"
  }
)
