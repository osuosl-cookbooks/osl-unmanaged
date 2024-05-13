#!/bin/bash
set -ex
if [ -e /usr/bin/apt-get ] ; then
  apt-get update
  apt-get -y install curl unzip build-essential
elif [ -e /usr/bin/dnf ] ; then
  dnf -y install curl unzip
elif [ -e /usr/bin/yum ] ; then
  yum -y install curl unzip
fi

if [ ! -e /opt/cinc/embedded/bin/gem ] ; then
  curl https://omnitruck.cinc.sh/install.sh | bash
fi

/opt/cinc/embedded/bin/gem install -N berkshelf
rm -rf /tmp/cinc
mkdir -p /tmp/cinc/cache /tmp/cinc/cookbooks
chmod -R 777 /tmp/cinc
curl -L -o /tmp/cinc/osl-unmanaged.zip \
  https://github.com/osuosl-cookbooks/osl-unmanaged/archive/refs/heads/main.zip
cd /tmp/cinc
unzip osl-unmanaged.zip
mv osl-unmanaged-main osl-unmanaged
cd osl-unmanaged
/opt/cinc/embedded/bin/berks vendor /tmp/cinc/cookbooks
cp bootstrap/client.rb /tmp/cinc/client.rb
cp bootstrap/runlist/unmanaged.json /tmp/cinc/dna.json

/opt/cinc/bin/cinc-client \
  --local-mode \
  --config /tmp/cinc/client.rb \
  --log_level auto \
  --force-formatter \
  --no-color \
  --json-attributes /tmp/cinc/dna.json \
  --chef-zero-port 8889


if [ -e /usr/bin/apt-get ] ; then
  apt-get -y purge cinc build-essential
elif [ -e /usr/bin/dnf ] ; then
  dnf -y remove cinc
elif [ -e /usr/bin/yum ] ; then
  yum -y remove cinc
fi

rm -rf /tmp/cinc /opt/cinc
