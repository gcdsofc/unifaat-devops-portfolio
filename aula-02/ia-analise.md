# Analise do Uso de IA - Aula 02 TF

## Prompt Utilizado

Crie um docker-compose.yml para uma aplicacao Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistencia. Todos os servicos devem estar na mesma rede bridge customizada. Use variaveis de ambiente com interpolacao de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped.

## Output Original do Kiro

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=db
      - DB_PORT=5432
      - DB_NAME=technova
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - db
      - redis
    networks:
      - backend

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=technova
      - POSTGRES_USER=technova
      - POSTGRES_PASSWORD=secret123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - backend

  redis:
    image: redis:latest
    networks:
      - backend

networks:
  backend:
    driver: bridge

volumes:
  postgres_data:
```

## Alteracoes que Fiz Manualmente

| O que mudei | Por que |
|---|---|
| Renomeei `app` para `api` e `db` para `postgres` | Para deixar os nomes mais claros e alinhados com o enunciado |
| Troquei `postgres:15` por `postgres:15-alpine` | A imagem alpine e mais leve e foi indicada no material da aula |
| Troquei `redis:latest` por `redis:7-alpine` | Evita usar `latest` e fixa a versao esperada |
| Removi senhas hardcoded | Senhas devem vir do `.env`, nao do `docker-compose.yml` |
| Adicionei `.env.example` | Facilita a configuracao por outros desenvolvedores sem versionar segredo |
| Adicionei healthchecks no PostgreSQL, Redis e API | Garante que os servicos sejam considerados prontos antes da API iniciar |
| Usei `depends_on` com `condition: service_healthy` | A API espera banco e cache ficarem saudaveis |
| Adicionei `restart: unless-stopped` | Melhora a resiliencia do ambiente local |
| Adicionei volume nomeado `pgdata` e rede `technova-network` | Atende aos requisitos de persistencia e comunicacao entre containers |
| Adicionei `init.sql` | Cria uma tabela inicial para demonstrar persistencia do PostgreSQL |
| Adicionei comentarios no Compose | Facilita leitura e manutencao do arquivo |

## O que o Kiro Acertou

- Separou os tres servicos principais: API, PostgreSQL e Redis.
- Usou Docker Compose para declarar rede e volume.
- Incluiu variaveis de ambiente para a API.
- Criou um bom ponto de partida para refinamento.

## O que o Kiro Errou ou Omitiu

- Usou senha hardcoded no arquivo Compose.
- Usou `redis:latest`, o que nao e recomendado.
- Nao adicionou healthchecks.
- Nao usou `depends_on` com condicao de healthcheck.
- Nao criou `.env.example`.
- Nao adicionou politica de restart.
- Nao incluiu comentarios explicativos.

## Minha Avaliacao

- **Tempo economizado usando IA:** cerca de 25 minutos.
- **Tempo gasto validando/corrigindo:** cerca de 20 minutos.
- **Nota para o output da IA (1-10):** 7.
- **Usaria novamente para este tipo de tarefa?** Sim. A IA ajuda muito a criar o primeiro rascunho, mas eu nao usaria o resultado sem revisar, testar e ajustar seguranca, versoes, healthchecks e variaveis de ambiente.
