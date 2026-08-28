# Aula 02 - Docker Compose e IA como Copiloto

## Objetivo

Criar um ambiente local multi-container para a TechNova usando Docker Compose.
O ambiente possui:

- API Node.js com Express
- Banco PostgreSQL 15
- Redis 7 para cache
- Rede bridge customizada
- Volume nomeado para persistencia do PostgreSQL
- Healthchecks e `depends_on` com condicao de servico saudavel
- Variaveis de ambiente separadas em `.env`

## Como executar

1. Copie o arquivo de exemplo:

```bash
cp .env.example .env
```

2. Suba o ambiente:

```bash
docker compose up -d --build
```

3. Verifique os servicos:

```bash
docker compose ps
```

4. Teste a API:

```bash
curl http://localhost:3000
curl http://localhost:3000/health
```

5. Teste PostgreSQL e Redis:

```bash
docker compose exec postgres psql -U technova -d technova -c "SELECT 1;"
docker compose exec redis redis-cli ping
```

6. Pare o ambiente:

```bash
docker compose down
```

## Arquivos

| Arquivo | Funcao |
|---|---|
| `app.js` | API Express da Aula 02 |
| `package.json` | Dependencias e script de inicializacao |
| `Dockerfile` | Imagem Docker da API |
| `.dockerignore` | Arquivos ignorados no build Docker |
| `docker-compose.yml` | Orquestracao API + PostgreSQL + Redis |
| `.env.example` | Template de configuracao |
| `.gitignore` | Arquivos locais que nao entram no Git |
| `ia-analise.md` | Analise critica do uso de IA |
| `ia-checklist.md` | Checklist pessoal para validar outputs de IA |
