# generic attribs
default["redmine"]["env"]               = 'production'
default["redmine"]["repo"]              = 'git://github.com/redmine/redmine.git'
default["redmine"]["revision"]          = '2.2.4'
default["redmine"]["deploy_to"]         = '/opt/redmine'
default["redmine"]["path"]              = '/var/www/redmine'
default["redmine"]["install_method"]    = "source"
default["redmine"]["install_rmagick"]   = true

# databases
default["redmine"]["databases"]["production"]["adapter"]    = 'mysql'
default["redmine"]["databases"]["production"]["database"]   = 'redmine'
default["redmine"]["databases"]["production"]["username"]   = 'redmine'
default["redmine"]["databases"]["production"]["password"]   = 'password'

# Packages for CentOS, minus postgres and MySQL, to be included at a later time
default["redmine"]["packages"] = {
    "ruby"    => %w{ ruby-devel },
    "apache"  => %w{ zlib-devel curl-devel openssl-devel httpd-devel apr-devel 
        apr-util-devel mod_passenger },
    "rmagick" => %w{ ImageMagick ImageMagick-devel }
}
