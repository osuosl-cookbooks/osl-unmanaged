# generic attribs
default["redmine"]["env"]               = 'production'
default["redmine"]["repo"]              = 'git://github.com/redmine/redmine.git'
default["redmine"]["revision"]          = '2.3.0'
default["redmine"]["deploy_to"]         = '/opt/redmine'
default["redmine"]["path"]              = '/var/www/redmine'
default["redmine"]["install_method"]    = "source"
default["redmine"]["install_rmagick"]   = true

# databases
default["redmine"]["databases"]["production"]["adapter"]    = 'pg2.osuosl.org'
default["redmine"]["databases"]["production"]["database"]   = 'fsslgy_redmine'
default["redmine"]["databases"]["production"]["username"]   = 'fsslgy_redmine'
default["redmine"]["databases"]["production"]["password"]   = 'test'

default["redmine"]["packages"] = {
  "ruby"    => %w{ ruby-devel },
  "apache"  => %w{ zlib-devel curl-devel openssl-devel httpd-devel apr-devel 
          apr-util-devel mod_passenger },
  "rmagick" => %w{ ImageMagick ImageMagick-devel }
}
