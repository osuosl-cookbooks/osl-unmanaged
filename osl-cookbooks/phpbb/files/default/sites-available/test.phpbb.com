<VirtualHost *:8080>
    ServerName test.phpbb.com
    ServerAlias www.test.phpbb.com
    ServerAdmin webmaster@phpbb.com

    DocumentRoot /var/www/test.phpbb.com/htdocs
    php_admin_value open_basedir ".:/tmp:/usr/share/php:/var/www/test.phpbb.com:/var/www/phpbb.com"

    RewriteEngine on
    AllowEncodedSlashes NoDecode
    RewriteCond %{HTTP_HOST} !^test\.phpbb\.com$ [NC]
    RewriteCond %{HTTP_HOST} !^local\.phpbb\.com$ [NC]
    RewriteRule (.*) http://test.phpbb.com$1 [R=301,L]

    # Deal with bots
    SetEnvIfNoCase user-agent "Link Sleuth" bad_bot=1
    SetEnvIfNoCase user-agent "HTTrack " bad_bot=1

    # Other performance settings
    Timeout 10
    KeepAlive Off

    # phpBB specific settings
    Include /var/www/test.phpbb.com/htdocs/.htdev

    ProxyRequests off
    ProxyPass /updatecheck http://version.phpbb.com/legacy
    ProxyPassReverse /updatecheck http://version.phpbb.com/legacy

    <Directory /var/www/test.phpbb.com/htdocs>
        Options FollowSymLinks
        AllowOverride All
        Order Allow,Deny
        Allow from all
        Deny from env=bad_bot
    </Directory>

    <FilesMatch "^\.ht">
        Order allow,deny
        Deny from all
    </FilesMatch>

    <Proxy *>
        Order allow,deny
        Allow from All
    </proxy>

    CustomLog "|/usr/sbin/rotatelogs /var/log/httpd/test.phpbb.com/transfer/%Y%m%d.log 86400" combined
    ErrorLog "|/usr/sbin/rotatelogs /var/log/httpd/test.phpbb.com/error/%Y%m%d.log 86400"
</VirtualHost>

<VirtualHost *:443>
    ServerName test.phpbb.com
    ServerAdmin webmaster@phpbb.com
    SSLEngine On

    DocumentRoot /var/www/test.phpbb.com/htdocs
    php_admin_value open_basedir ".:/tmp:/usr/share/php:/var/www/test.phpbb.com:/var/www/phpbb.com"

    RewriteEngine on
    AllowEncodedSlashes NoDecode
    RewriteCond %{HTTP_HOST} !^test\.phpbb\.com$ [NC]
    RewriteCond %{HTTP_HOST} !^local\.phpbb\.com$ [NC]
    RewriteRule (.*) http://test.phpbb.com$1 [R=301,L]

    # Deal with bots
    SetEnvIfNoCase user-agent "Link Sleuth" bad_bot=1
    SetEnvIfNoCase user-agent "HTTrack " bad_bot=1

    # Other performance settings
    Timeout 10
    KeepAlive Off

    # phpBB specific settings
    Include /var/www/test.phpbb.com/htdocs/.htdev

    ProxyRequests off
    ProxyPass /updatecheck http://version.phpbb.com/legacy
    ProxyPassReverse /updatecheck http://version.phpbb.com/legacy

    <Directory /var/www/test.phpbb.com/htdocs>
        Options FollowSymLinks
        AllowOverride All
        Order Allow,Deny
        Allow from all
        Deny from env=bad_bot
    </Directory>

    <FilesMatch "^\.ht">
        Order allow,deny
        Deny from all
    </FilesMatch>

    <Proxy *>
        Order allow,deny
        Allow from All
    </proxy>

    CustomLog "|/usr/sbin/rotatelogs /var/log/httpd/test.phpbb.com/transfer/%Y%m%d.log" combined
    ErrorLog "|/usr/sbin/rotatelogs /var/log/httpd/test.phpbb.com/error/%Y%m%d.log"
</VirtualHost>
