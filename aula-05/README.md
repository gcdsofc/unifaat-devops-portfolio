# Aula 05 - RDS e Remote State

Infraestrutura Terraform da TechNova com banco PostgreSQL gerenciado no Amazon RDS e state remoto protegido em S3 + DynamoDB.

## Arquitetura

```text
Internet
   |
   v
Internet Gateway
   |
   v
VPC technova-aula05 - 10.0.0.0/16
|
|-- Subnet publica 10.0.1.0/24
|   `-- EC2 t2.micro com cliente PostgreSQL
|
|-- Subnet privada A 10.0.2.0/24
|   `-- RDS PostgreSQL via DB Subnet Group
|
`-- Subnet privada B 10.0.3.0/24
    `-- RDS PostgreSQL via DB Subnet Group

Terraform Remote State:
S3 bucket + versionamento + criptografia + block public access
DynamoDB table com LockID para locking
```

## Estrutura

| Pasta | Funcao |
|---|---|
| `backend/` | Cria bucket S3 e tabela DynamoDB para remote state |
| `main/` | Cria VPC, EC2, RDS, Security Groups e usa backend S3 |

## Ordem de execucao

1. Criar o backend:

```bash
cd backend
terraform init
terraform plan
terraform apply
```

2. Criar a infraestrutura principal:

```bash
cd ../main
terraform init
terraform plan
terraform apply
```

3. Testar state remoto:

```bash
aws s3 ls s3://technova-tfstate-6325300-aula05/aula-05/main/
```

4. Testar conexao EC2 para RDS:

```bash
ssh -i ~/.ssh/technova-key ec2-user@$(terraform output -raw ec2_public_ip)
psql -h <rds_address> -U technova_admin -d technova -c "SELECT version();"
```

5. Destruir ao final:

```bash
cd main
terraform destroy

cd ../backend
aws s3 rm s3://technova-tfstate-6325300-aula05 --recursive
terraform destroy
```

## Decisoes tecnicas

| Decisao | Motivo |
|---|---|
| RDS em subnets privadas | Banco nao deve ser acessivel diretamente pela internet |
| 2 subnets privadas em AZs diferentes | Requisito do DB Subnet Group da AWS |
| SG do RDS permitindo apenas SG da EC2 | Menor privilegio melhor que liberar toda a VPC |
| S3 com versionamento | Recupera historico do state |
| DynamoDB LockID | Evita dois applies simultaneos corrompendo o state |
| `terraform.tfvars` ignorado | Evita versionar senha do banco e outros segredos |

## Evidencias locais geradas

- `backend/terraform-plan-output.txt`: plano do backend S3 + DynamoDB.
- `main/terraform-plan-output.txt`: plano da infraestrutura principal.

As evidencias de `aws s3 ls`, `psql` e `terraform plan` limpo depois de `apply` precisam ser capturadas no AWS Academy Learner Lab ativo.
