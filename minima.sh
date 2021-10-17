#!/bin/bash

#firewal setup

sudo apt update
sudo apt install ufw -y
sudo ufw allow 22:65535/tcp
sudo ufw allow 22:65535/udp
sudo ufw deny out from any to 10.0.0.0/8
sudo ufw deny out from any to 192.168.0.0/16
sudo ufw deny out from any to 169.254.0.0/16
sudo ufw deny out from any to 198.18.0.0/15
sudo ufw deny out from any to 100.64.0.0/10
sudo ufw --force enable

apt update
apt install mc wget jq libfontconfig1 libxtst6 libxrender1 libxi6 java-common -y
wget https://cdn.azul.com/zulu/bin/zulu11.48.21-ca-jdk11.0.11-linux_amd64.deb
dpkg -i zulu11.48.21-ca-jdk11.0.11-linux_amd64.deb

wget https://github.com/minima-global/Minima/raw/master/jar/minima.jar

sudo apt install --fix-broken -y

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/minima.service
[Unit]
Description=minima
[Service]
User=$USER
ExecStart=/usr/bin/java -Xmx1G -jar $HOME/minima.jar -daemon
Restart=always
RestartSec=100
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minima
sudo systemctl start minima

echo -e '\n\e[44mRun command to see logs: \e[0m\n'
echo 'journalctl -n 100 -f -u minima'
