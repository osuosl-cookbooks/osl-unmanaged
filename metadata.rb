name              'osl-unmanaged'
maintainer        'Oregon State University'
maintainer_email  'chef@osuosl.org'
license           'Apache-2.0'
description       'Installs/Configures osl-unmanaged'
issues_url        'https://github.com/osuosl-cookbooks/osl-unmanaged/issues'
source_url        'https://github.com/osuosl-cookbooks/osl-unmanaged'
chef_version      '>= 16.0'
version           '2.5.0'

supports          'centos', '~> 7.0'
supports          'almalinux', '~> 8.0'
supports          'almalinux', '~> 9.0'
supports          'centos_stream', '~> 8.0'
supports          'debian', '11.0'
supports          'ubuntu', '~> 20.04'
supports          'ubuntu', '~> 22.04'

depends 'line'
