#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/technova-aula05-user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

dnf update -y
dnf install -y postgresql15 git curl

cat > /home/ec2-user/README-rds-test.txt <<'TEXT'
Use o output connection_string do Terraform para testar o RDS:

psql -h <rds_address> -U technova_admin -d technova -p 5432

Depois de conectar:

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  product TEXT NOT NULL,
  status TEXT NOT NULL
);

INSERT INTO orders (product, status) VALUES
('Widget A', 'created'),
('Widget B', 'processing'),
('Widget C', 'shipped');

SELECT * FROM orders;
TEXT

chown ec2-user:ec2-user /home/ec2-user/README-rds-test.txt
