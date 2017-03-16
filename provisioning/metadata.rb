name             'provisioning'
maintainer       'Oregon State University'
maintainer_email 'systems@osuosl.org'
license          'Apache 2.0'
description      'Installs/Configures provisioning'
long_description 'Installs/Configures provisioning'
version          '0.0.1'

depends 'base'
depends 'certificate'
depends 'firewall'
depends 'logrotate'
depends 'ntp'
depends 'omnibus'
depends 'openssh'
depends 'osl-dhcp'
depends 'osl-dns'
depends 'osl-jenkins'
depends 'osl-haproxy'
depends 'osl-nagios'
depends 'osl-openstack'
depends 'osl-vpn'
depends 'postfix'
depends 'sudo'
depends 'sysctl', '= 0.7.0'
depends 'selinux_policy', '= 0.9.1'
depends 'yum-epel', '= 0.6.5'
