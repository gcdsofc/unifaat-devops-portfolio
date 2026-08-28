CREATE TABLE IF NOT EXISTS pedidos (
  id SERIAL PRIMARY KEY,
  cliente VARCHAR(120) NOT NULL,
  item VARCHAR(120) NOT NULL,
  quantidade INTEGER NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'pendente',
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO pedidos (cliente, item, quantidade, status) VALUES
  ('TechNova Corp', 'Licenca Enterprise', 1, 'aprovado'),
  ('StartupXYZ', 'Plano Basico', 3, 'pendente'),
  ('MegaLtda', 'Consultoria DevOps', 1, 'em_andamento');
