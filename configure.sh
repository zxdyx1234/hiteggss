#!/bin/sh
# xray generate configuration
# Download and install xray
config_path=$PROTOCOL"_ws_tls.json"
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray
# Remove temporary directory
rm -rf /tmp/xray
# xray new configuration
install -d /usr/local/etc/xray
envsubst '\$UUID,\$WS_PATH' < $config_path > /usr/local/etc/xray/config.json
# MK TEST FILES
mkdir /opt/test
cd /opt/test
dd if=/dev/zero of=100mb.bin bs=100M count=1
dd if=/dev/zero of=10mb.bin bs=10M count=1
# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json &
# Run nginx
/bin/bash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
