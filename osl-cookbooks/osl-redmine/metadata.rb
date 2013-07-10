name             'osl-redmine'
maintainer       'OSU Open Source Lab'
maintainer_email 'coreyg@osuosl.org'
license          'All rights reserved'
description      'Installs/Configures osl-redmine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'build-essential'
depends 'yum'
depends 'database'
depends 'postgresql'
