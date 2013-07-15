name "openldap"
description "ldap server role"
run_list(
  "role[base_managed]",
  "recipe[osl-slapd]",
  "recipe[firewall::openldap]"
)
override_attributes(
  "osl-slapd" => {
    "rootpw" => "{SSHA}45XuCvh2KTCJNJuDDx3o7QsSSGypQ4tm",
    "suffix" => "dc=osuosl,dc=org",
    "access" => [
      'access to attrs=userPassword by group.exact="cn=Admin,dc=osuosl,dc=org" write by dn="uid=syncuser,dc=osuosl,dc=org" read by anonymous auth by self write by * none',
      'access to attrs=mail,telephoneNumber,facsimileTelephoneNumber,mobile,sshPublicKey by group.exact="cn=Admin,dc=osuosl,dc=org" write by dn="uid=syncuser,dc=osuosl,dc=org" read by self write by * read',
      'access to * by group.exact="cn=Admin,dc=osuosl,dc=org" write by dn="uid=syncuser,dc=osuosl,dc=org" read by * read'
    ]
  }
)
