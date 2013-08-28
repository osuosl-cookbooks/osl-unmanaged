include_recipe git
include_recipe apache2
include_recipe apache2::mod_wsgi
include_recipe python

file '/var/www/prerelease_website/prerelease_website/logfile' do
    action :create
    owner 'apache'
    group 'apache'
end
