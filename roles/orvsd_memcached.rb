name "orvsd_memcached"
description "orvsd memcached role"
run_list(
  "recipe[memcached]",
  "recipe[orvsd-web::memcache]"
)
override_attributes(
  "memcached" => {
    "memory" => "384"
  }
)
