# Certificate [![Build Status](https://secure.travis-ci.org/atomic-penguin/cookbook-certificate.png?branch=master)](http://travis-ci.org/atomic-penguin/cookbook-certificate)

## Description

This recipe automates the common task of managing x509 certificates and keys
from encrypted Data Bags.  This cookbook provides a flexible and re-usable
LWRP which can be plugged into other recipes, such as the postfix or apache2
cookbooks.

### Important note

The KITCHEN.md documents the `test/integration` files used to validate
the certificate\_manage LWRP converges correctly.  Files in the `test/integration`
should not be used in production.  Files include a self-signed "snake oil" certificate/key
and an encrypted\_data\_bag\_secret file which are not secure to use beyond testing.

## Requirements

You do need to prepare an encrypted data bag, containing the certificates,
private keys, and CA bundles you wish to deploy to servers with the LWRP.
I used Joshua Timberman's [blog post](https://jtimberman.posterous.com/64227128),
and the Opscode [Wiki documentation](http://wiki.opscode.com/display/chef/Encrypted+Data+Bags)
as a reference in creating this cookbook.

First, create a **data bag secret** as follows.  You need to manually copy
the *encrypted_data_bag_secret* to */etc/chef* on your servers, or place it
there as part of your bootstrap process.  For example, you may choose to
do deploy the secret file with kickstart or preseed as part of the OS
install process. 

    openssl rand -base64 512 > ~/.chef/encrypted_data_bag_secret

Second, create a data bag, the default data bag within the LWRP is
named *certificates*.  However, you may override this with the
*data_bag* LWRP attribute.

    knife data bag create certificates

You need to convert your certificate, private keys, and CA bundles into
single-line blobs with literal \n characters.  This is so it may be
copy/pasted into your data bag.  You can use a Perl or Ruby one-liner for
this conversion.

    /usr/bin/env ruby -e 'p ARGF.read' <filename>
    -OR-
    perl -pe 's!(\x0d)?\x0a!\\n!g' <filename>

What we're trying to accomplish is converting this:

    -----BEGIN CERTIFICATE-----
    MIIEEDCCA3mgAwIBAgIJAO4rOcmpIFmPMA0GCSqGSIb3DQEBBQUAMIG3MQswCQYD
    -----END CERTIFICATE-----

Into this:

    -----BEGIN CERTIFICATE-----\nMIIEEDCCA3mgAwIBAgIJAO4rOcmpIFmPMA0GCSqGSIb3DQEBBQUAMIG3MQswCQYD\n-----END CERTIFICATE-----

Finally, you'll want to create the data bag object to contain your certs,
keys, and optionally your CA root chain bundle.  The default recipe uses
the OHAI attribute *hostname* as a *search_id*, since the data bag id may not 
contain dot characters used in the *fqdn* attribute.

The cookbook also contains an example *wildcard* recipe to use with wildcard
certificates (\*.example.com) certificates.

Hostname mail as data bag search_id:

    knife data bag create certificates mail --secret-file ~/.chef/encrypted_data_bag_secret

The resulting encrypted data bag for a hostname should be structured like so.
The *chain* id may be optional if your CA's root chain is already trusted by the
server.

    {
      "id": "mail",
      "cert": "-----BEGIN CERTIFICATE-----\nMail Certificate Here...",
      "key": "-----BEGIN PRIVATE KEY\nMail Private Key Here...",
      "chain": "-----BEGIN CERTIFICATE-----\nCA Root Chain Here..."
    }


Wildcard certificate as data bag search_id:

    knife data bag create certificates wildcard --secret-file ~/.chef/encrypted_data_bag_secret

The resulting encrypted data bag should be structured like so for a wildcard
certificate.  The *chain* id may be optional if your CA's root chain is already
trusted by the server.

    {
      "id": "wildcard",
      "cert": "-----BEGIN CERTIFICATE-----\nWildcard Certificate Here...",
      "key": "-----BEGIN PRIVATE KEY\nWildcard Private Key Here...",
      "chain": "-----BEGIN CERTIFICATE-----\nCA Root Chain Here..."
    }


## Recipes

This cookbook comes with two simple example recipes for using the *certificate_manage* LWRP.

### default

Searches the data bag, *certificates*, for an object with an *id* matching
*node.hostname*.  Then the recipe places the decrypted certificates and keys
in either */etc/pki/tls* (RHEL family), or */etc/ssl* (Debian family).  The
default owner and group owner of the resulting files are *root*.

The resulting files will be named {node.fqdn}.pem (cert),
{node.fqdn}.key (key), and {node.hostname}-bundle.crt (CA Root chain).

### wildcard

Same as the default recipe, except for the search *id* is *wildcard*.
The resulting files will be named wildcard.pem (cert), wildcard.key (key),
and wildcard-bundle.crt (CA Root chain)

### manage_by_attributes

Retrieve search keys from attributes "certificate".  
Set ID and LWRP attributes to node attribute following...

    "certificate": [
      {"self": null},
      {"mail": {
        "cert_path": "/etc/postfix/ssl",
         "owner": "postfix",
         "group": "postfix"
        }
      },
    ]


## Resources/Providers

### resources

The LWRP resource attributes are as follows.

  * data\_bag - Data bag index to search, defaults to certificates
  * data\_bag\_secret - Path to the file with the data bag secret
  * search\_id - Data bag id to search for, defaults to provider name
  * cert\_path - Top-level SSL directory, defaults to vendor specific location
  * cert\_file - The basename of the x509 certificate, defaults to {node.fqdn}.pem
  * key\_file - The basename of the private key file, defaults to {node.fqdn}.key
  * chain\_file - The basename of the x509 certificate, defaults to {node.hostname}-bundle.crt
  * owner - The file owner, defaults to root
  * group - The file group owner, defaults to root
  * cookbook - The cookbook containing the erb template, defaults to certificate
  * create\_subfolders - Enable/disable auto-creation of private/certs subdirectories.  Defaults to true

### providers

  * certificate\_manage - The reusable LWRP to manage certificates, keys, and CA bundles

## Usage

Here is a flushed out example using the LWRP to manage your certificate
items on a Postfix bridgehead.  The following example should select the
*mail* data bag object, from the *certificates* data bag.

It should then place the managed certificate files in */etc/postfix/ssl*,
and change the owner/group to *postfix*.

```ruby
certificate_manage "mail" do
  cert_path "/etc/postfix/ssl"
  owner "postfix"
  group "postfix"
end
```      

## License and Author

Author:: Eric G. Wolfe <wolfe21@marshall.edu> 

Copyright:: 2012, Eric G. Wolfe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
