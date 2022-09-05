#!/bin/sh

echo
echo "Install Fixuid..."
curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.3/fixuid-0.3-linux-amd64.tar.gz \
  | tar -C /usr/local/bin -xzf - \
  && chown root:root /usr/local/bin/fixuid \
  && chmod 4755 /usr/local/bin/fixuid \
  && mkdir -p /etc/fixuid \
  && printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

