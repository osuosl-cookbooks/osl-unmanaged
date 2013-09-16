<VirtualHost *:8080>
    ServerName www.phpbb.com
    ServerAlias phpbb.com temp.phpbb.com dev.phpbb.com phpbb.osuosl.org www2.phpbb.com

    RewriteEngine on
    AllowEncodedSlashes NoDecode
    RewriteCond %{HTTP_HOST} !^www\.phpbb\.com$ [NC]
    RewriteCond %{HTTP_HOST} !^local\.phpbb\.com$ [NC]
    RewriteRule (.*) http://www.phpbb.com$1 [R=301,L]

    Include /etc/httpd/sites-available/standard.include
</VirtualHost>

<VirtualHost *:443>
    ServerName www.phpbb.com
    ServerAlias phpbb.com temp.phpbb.com dev.phpbb.com phpbb.osuosl.org www2.phpbb.com

    RewriteEngine on
    AllowEncodedSlashes NoDecode
    RewriteCond %{HTTP_HOST} !^www\.phpbb\.com$ [NC]
    RewriteCond %{HTTP_HOST} !^local\.phpbb\.com$ [NC]
    RewriteRule (.*) http://www.phpbb.com$1 [R=301,L]

    SSLEngine On
    Include /etc/httpd/sites-available/standard.include
</VirtualHost>

<VirtualHost *:443>
    ServerName www1-pingdom.phpbb.com
    ServerAlias lb1-pingdom.phpbb.com


    SSLEngine On
    Include /etc/httpd/sites-available/standard.include
    Include /etc/httpd/sites-available/pingdom.include
</VirtualHost>

<VirtualHost *:8080>
    ServerName www1-pingdom.phpbb.com
    ServerAlias lb1-pingdom.phpbb.com

    Include /etc/httpd/sites-available/standard.include
    Include /etc/httpd/sites-available/pingdom.include
</VirtualHost>
