<div align="center">
  <img width="128" src="./logo.png" alt="ServiceNow logo" />
  <h1>ServiceNow Web Proxy</h1>
  <p>Container image for providing reverse proxy services to ServiceNow developer instances via Apache</p>
  <hr />
  <br />
  <a href="#">
    <img src="https://img.shields.io/badge/stability-alpha-ff69b4?style=for-the-badge" />
  </a>
  <a href="https://en.wikipedia.org/wiki/MIT_License" target="_blank">
    <img src="https://img.shields.io/badge/license-MIT-maroon?style=for-the-badge" />
  </a>
</div>
<br />
<hr />
<br />

## ServiceNow Vanity URLs

This image serves as a reverse proxy for ServiceNow instances in order to provide custom vanity URLs.

To define a vanity URL, you should create an Apache configuration file such as the one below in the `/usr/local/apache2/conf.d/vhosts` folder with a `.conf` extension.

```
<VirtualHost *:80>
  ServerName snow.mydomain.com
  ServerAlias servicenow.mydomain.com
  DocumentRoot /usr/local/apache2/htdocs

  ErrorLog /proc/self/fd/2
  TransferLog /proc/self/fd/1

  RewriteEngine On
  RewriteCond %{HTTPS} off
  RewriteRule (.*) https://%{HTTP_HOST}$1 [R,L]
</VirtualHost>

<VirtualHost *:443>
  ServerName snow.mydomain.com
  ServerAlias servicenow.mydomain.com
  DocumentRoot /usr/local/apache2/htdocs

  ErrorLog /proc/self/fd/2
  TransferLog /proc/self/fd/1
  CustomLog /proc/self/fd/1 "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

  SSLEngine on
  SSLProxyEngine on
  SSLCertificateFile /usr/local/apache2/certs/snow.crt
  SSLCertificateKeyFile /usr/local/apache2/certs/snow.pem

  <FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
  </FilesMatch>
  <Directory "/usr/local/apache2/cgi-bin">
    SSLOptions +StdEnvVars
  </Directory>

  BrowserMatch "MSIE [2-5]" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0

  ProxyRequests on
  ProxyPass / https://dev123456.service-now.com/
</VirtualHost>
```

If you choose to use the virtual host configuration above, you will need to alter the following:

- Be sure to update the `ServerName` and `ServerAlias` (or comment it out if not being used) with the FQDN(s) of the host names that you wish to use for your ServiceNow vanity URL
- Within the `/usr/local/apache2/certs` folder inside the container, place a legitimate SSL certificate in a file named `snow.crt` (or alter the `SSLCertificateFile` setting) and the private key in a file named `snow.pem` (or alter the `SSLCertificateKeyFile` setting).
- Be sure the SSL private key is set to mode `0600` or `0640` and owned by uid `2`.

## Additional Help or Questions

If you have questions about this project, find a bug or wish to submit a feature request, please [submit an issue](https://github.com/josh-hogle/snow-web-proxy/issues).
