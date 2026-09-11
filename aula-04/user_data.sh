#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/technova-user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

APP_DIR="/opt/technova-api"
APP_REPO="https://github.com/AleTavares/technova-api.git"

dnf update -y
dnf install -y git curl

curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
dnf install -y nodejs

mkdir -p "$APP_DIR"

if git ls-remote "$APP_REPO" >/dev/null 2>&1; then
  git clone "$APP_REPO" "$APP_DIR"
else
  cat > "$APP_DIR/package.json" <<'JSON'
{
  "name": "technova-api",
  "version": "1.0.0",
  "description": "API simplificada da TechNova para a Aula 04",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.3"
  }
}
JSON

  cat > "$APP_DIR/server.js" <<'JS'
const express = require("express");
const os = require("os");

const app = express();
const port = process.env.PORT || 3000;

app.get("/", (_req, res) => {
  res.json({
    message: "TechNova API - Rodando na AWS!",
    service: "technova-api",
    hostname: os.hostname(),
    timestamp: new Date().toISOString()
  });
});

app.get("/health", (_req, res) => {
  res.json({
    status: "healthy",
    service: "technova-api"
  });
});

app.get("/orders", (_req, res) => {
  res.json({
    orders: [
      { id: 1, product: "Widget A", status: "shipped" },
      { id: 2, product: "Widget B", status: "processing" }
    ]
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`TechNova API listening on port ${port}`);
});
JS
fi

cd "$APP_DIR"
npm install --omit=dev

chown -R ec2-user:ec2-user "$APP_DIR"

cat > /etc/systemd/system/technova-api.service <<'SERVICE'
[Unit]
Description=TechNova API
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/technova-api
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now technova-api
