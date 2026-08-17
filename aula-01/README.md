# Aula 01 - Fundamentos de Git e Docker

## O que aprendi

- Git resolve o problema de perder versoes do codigo, porque cada commit registra uma mudanca com historico, autor e mensagem.
- A area de staging permite escolher exatamente o que vai entrar no proximo commit.
- Branches deixam o desenvolvimento mais seguro, pois permitem criar funcionalidades sem mexer diretamente na `main`.
- O `.gitignore` evita que arquivos desnecessarios ou sensiveis, como `node_modules/` e `.env`, sejam versionados.
- Docker resolve o problema "funciona na minha maquina" ao empacotar aplicacao, runtime e dependencias em uma imagem reproduzivel.
- O Dockerfile tambem deve ser versionado no Git, porque ele documenta como o ambiente da aplicacao e construido.

## Comandos Git praticados

- `git init`
- `git status`
- `git add`
- `git commit`
- `git checkout -b`
- `git log --oneline`

## Comandos Docker praticados

- `docker --version`
- `docker compose version`
- `docker build`
- `docker run`
- `docker ps`
- `docker logs`
- `docker stop`
- `docker rm`

## Como executar este container

```bash
cd aula-01/app
docker build -t portfolio-aula01:1.0 .
docker run -d --name portfolio-test -p 3000:3000 portfolio-aula01:1.0
curl http://localhost:3000
curl http://localhost:3000/health
```

## Como executar sem Docker

```bash
cd aula-01/app
npm install
npm start
```

## Dificuldades encontradas

- O Docker estava instalado, mas o Docker Engine nao estava rodando no inicio da atividade. A solucao e abrir o Docker Desktop antes de executar os testes de container.
- Depois de iniciar o Docker Desktop, consegui construir a imagem, rodar o container e registrar a evidencia em `docker-logs.txt`.
