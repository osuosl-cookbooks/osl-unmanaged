name             'lanparty'
maintainer       'OSU Open Source Lab'
maintainer_email 'rudy@grigar.net'
license          'All rights reserved'
description      'Installs/Configures lanparty'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'simple_iptables', '~> 0.3.0'

recipe           'urbanterror', "UrbanTerror configuration"
recipe           'tf2', "Team Fortress 2 configuration"
