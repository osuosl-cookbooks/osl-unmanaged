name             'racktables'
maintainer       'OSU Open Source Lab'
maintainer_email 'bramwelt@osuosl.org'
license          'All rights reserved'
description      'Manages deploying Racktables: the datacenter asset manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'racktables::default', 'Install from source, and setup web app'
recipe 'racktables::source', 'Install racktables for source tarball'

depends 'apache2'
