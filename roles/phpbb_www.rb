name "phpbb_www"
description "phpbb web node"
run_list(
  "role[base_managed]",
  "recipe[phpbb::apache]",
  "recipe[phpbb::memcache]",
  "recipe[phpbb::users]",
  "recipe[phpbb::gluster]"
) 
override_attributes(
  "memcached" => {
    "memory" => "256"
  },
  "base" => {
    "packages" => %w[ vim bash-completion cronie cronie-anacron crontabs dmidecode htop iotop pv pwgen screen strace time ]
  }
)
