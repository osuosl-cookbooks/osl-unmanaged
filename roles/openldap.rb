name "openldap"
description "ldap server role"
run_list(
  "recipe[openldap::server]"
)
override_attributes(
  "openldap" => {
    "rootpw" => "{SSHA}aP1JdkMLJwIIFLZJCuP0A3HLAOnXa3kZ"
  }
)
