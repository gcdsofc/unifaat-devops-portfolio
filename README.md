# Portfolio DevOps - UniFAAT 2026-2

**Aluno:** Gabriel Carneiro da Silva  
**RA:** 6325300  
**Disciplina:** DevOps - Centro Universitario UniFAAT  
**Professor:** Alexandre Tavares  
**Semestre:** 2026-2

## Sobre

Repositorio de atividades e projetos da disciplina de DevOps.
Aqui documento minha evolucao desde os fundamentos de Git e Docker ate pipelines completas de CI/CD.

## Estrutura

- `aula-01/` - Fundamentos de Git e Docker
- `aula-02/` - Docker Compose e IA como copiloto DevOps
- `aula-03/` - Terraform e seguranca AWS com IAM
- `aula-04/` - Terraform VPC, networking AWS e EC2 Multi-AZ
- `aula-05/` - RDS PostgreSQL e remote state com S3 + DynamoDB
- `aula-06/` - Modulos Terraform reutilizaveis para VPC, SG, EC2 e RDS

## Aprendizados

Na Aula 01, comecei pela base de DevOps: versionar codigo com Git e padronizar ambiente com Docker.
O objetivo e sair do caos de arquivos soltos e ambientes diferentes para um fluxo reproduzivel, rastreavel e pronto para evoluir nas proximas aulas.

Na Aula 02, evolui o ambiente para uma aplicacao multi-container com Docker Compose.
A API agora sobe junto com PostgreSQL e Redis em um unico comando, usando rede customizada, volume nomeado, healthchecks e variaveis de ambiente fora do codigo.

Na Aula 03, comecei a trabalhar com Infraestrutura como Codigo usando Terraform.
O foco foi desenhar uma estrutura IAM segura para a TechNova, com users, groups, policies customizadas, service role para EC2 e aplicacao do principio do menor privilegio.

Na Aula 04, evolui a infraestrutura para uma VPC customizada Multi-AZ.
O projeto cria subnets publicas e privadas, Internet Gateway, Route Table publica, Security Groups, Key Pair, EC2 t2.micro com User Data e Instance Profile para a API da TechNova.

Na Aula 05, adicionei a camada de dados com Amazon RDS PostgreSQL e protegi o state do Terraform usando S3 com versionamento, criptografia e DynamoDB para locking.
O foco foi separar dados persistentes da instancia EC2 e evitar perda/corrupcao do `terraform.tfstate`.

Na Aula 06, refatorei a infraestrutura para uma biblioteca de modulos Terraform.
O projeto agora tem modulos reutilizaveis para VPC, Security Group, EC2 e RDS, com ambientes `dev` e `staging` usando a mesma base de codigo e variaveis diferentes.
