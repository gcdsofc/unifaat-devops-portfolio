# Checklist de Validacao para Output de IA - DevOps

- [x] Sintaxe valida com `docker compose config`
- [x] Imagens Docker com versoes especificas
- [x] Variaveis sensiveis fora do `docker-compose.yml`
- [x] `.env.example` versionado
- [x] `.env` ignorado pelo Git
- [x] Healthchecks configurados
- [x] `depends_on` usando `condition: service_healthy`
- [x] Volume nomeado declarado para persistencia
- [x] Rede customizada declarada
- [x] Ambiente testado com `docker compose up -d --build`
- [x] API testada em `/` e `/health`
- [x] PostgreSQL testado com `SELECT 1`
- [x] Redis testado com `redis-cli ping`
