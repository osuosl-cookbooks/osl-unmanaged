name "phpbb_www"
description "phpbb web node"
run_list(
  "role[base_managed]",
  "recipe[phpbb::apache]",
  "recipe[phpbb::memcache]",
  "recipe[phpbb::users]"
) 
override_attributes(
  "memcached" => {
    "memory" => "64"
  },
  "base" => {
    "packages" => %w[ vim bash-completion cronie cronie-anacron crontabs dmidecode htop iotop pv pwgen screen strace time ]
  }
)
