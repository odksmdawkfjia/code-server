#!/bin/bash

set -e

echo "[+] Installing code-server compatible version..."

cd /tmp
curl -L https://github.com/coder/code-server/releases/download/v4.8.3/code-server-4.8.3-linux-amd64.tar.gz -o cs.tar.gz

tar -xzf cs.tar.gz

rm -rf /usr/lib/code-server
mv code-server-4.8.3-linux-amd64 /usr/lib/code-server

ln -sf /usr/lib/code-server/bin/code-server /usr/bin/code-server

echo "[+] Creating config..."

mkdir -p ~/.config/code-server

cat <<EOF > ~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: yourpassword
cert: false
EOF

echo "[+] Creating systemd service..."

cat <<EOF > /etc/systemd/system/code-server.service
[Unit]
Description=code-server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/code-server
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

echo "[+] Enabling service..."

systemctl daemon-reload
systemctl enable code-server
systemctl restart code-server

echo "[✓] code-server installed"
echo "Access: http://SERVER-IP:8080"
echo "Password: 6969"
