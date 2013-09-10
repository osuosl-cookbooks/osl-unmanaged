name             'ros-docs'
maintainer       'OSU Open Source Lab'
maintainer_email 'rudy@grigar.net'
license          'Apache 2.0'
description      'Installs/Configures ros-docs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

# Dependencies
depends          'apache2'
depends          'simple_iptables'
depends          'base'
depends          'user'