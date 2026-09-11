# Infraestrutura TechNova - Aula 04

Infraestrutura como Codigo para uma VPC Multi-AZ da TechNova com subnets publicas e privadas, Internet Gateway, Route Table publica, Security Groups, EC2 `t2.micro`, Key Pair, User Data e Instance Profile.

## Diagrama da arquitetura

```text
Internet
   |
   v
Internet Gateway technova-igw
   |
   v
VPC technova-vpc - 10.0.0.0/16
|-- AZ A
|   |-- Subnet publica  10.0.1.0/24 -> EC2 API Node.js :3000
|   `-- Subnet privada  10.0.2.0/24 -> Banco futuro
|
`-- AZ B
    |-- Subnet publica  10.0.3.0/24 -> alta disponibilidade
    `-- Subnet privada  10.0.4.0/24 -> banco/cache futuros

Route Table publica: 0.0.0.0/0 -> Internet Gateway
Subnets privadas: apenas rota local da VPC
API SG: SSH 22 e API 3000 publicos
DB SG: PostgreSQL 5432 apenas de 10.0.0.0/16
```

## Pre-requisitos

- Terraform `>= 1.6.0`
- AWS CLI configurado com credenciais do AWS Academy ou da conta autorizada
- Chave SSH para acessar a instancia:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/technova-key -C "technova-aula-04"
```

No Windows PowerShell, o caminho equivalente fica em `$HOME\.ssh\technova-key`.

## Como usar

Inicialize e valide:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```

Por padrao, a AMI do Amazon Linux 2023 e buscada por data source. Se a conta usada para gerar o `plan` nao tiver permissao `ec2:DescribeImages`, use temporariamente uma AMI conhecida da regiao:

```bash
terraform plan -var="ami_id_override=ami-0c101f26f147fa7fd"
```

Aplicar:

```bash
terraform apply
```

Testar a API depois de 2 a 3 minutos:

```bash
terraform output -raw api_url
curl "$(terraform output -raw api_url)"
curl "$(terraform output -raw api_url)/health"
```

Testar SSH:

```bash
ssh -i ~/.ssh/technova-key ec2-user@$(terraform output -raw ec2_public_ip)
node --version
aws sts get-caller-identity
```

Gerar evidencias:

```bash
terraform plan > terraform-plan-output.txt
curl "$(terraform output -raw api_url)" > evidencia-api.json
curl "$(terraform output -raw api_url)/health" >> evidencia-api.json
ssh -i ~/.ssh/technova-key ec2-user@$(terraform output -raw ec2_public_ip) "node --version && aws sts get-caller-identity" > evidencia-ssh.txt
```

Destruir tudo ao final:

```bash
terraform destroy
```

## AWS Academy Learner Lab

O TF pede uma IAM Role dedicada com a policy `AmazonS3ReadOnlyAccess`, por isso o padrao deste projeto cria a Role e o Instance Profile.

Se o Learner Lab bloquear a criacao de IAM, aplique usando o Instance Profile ja existente:

```bash
terraform apply -var="use_lab_instance_profile=true"
```

## Decisoes tecnicas

| Decisao | Motivo |
|---|---|
| VPC customizada `10.0.0.0/16` | Isola a rede da TechNova e deixa espaco para crescimento |
| 2 AZs | Aumenta disponibilidade e prepara o ambiente para producao |
| 2 subnets publicas | Permitem recursos expostos, como API ou Load Balancer |
| 2 subnets privadas | Reservadas para banco, cache e workers sem entrada direta da internet |
| Sem NAT Gateway | Evita custo no laboratorio; privadas ficam sem internet publica |
| SG da API separado do SG do banco | Aplica separacao de responsabilidade e menor privilegio |
| User Data em arquivo separado | Facilita revisao e manutencao do script de bootstrap |

## Recursos criados

| Recurso | Nome | Funcao |
|---|---|---|
| VPC | `technova-vpc` | Rede principal isolada |
| Subnets publicas | `technova-public-a`, `technova-public-b` | Camada publica em duas AZs |
| Subnets privadas | `technova-private-a`, `technova-private-b` | Camada privada para banco/cache futuros |
| Internet Gateway | `technova-igw` | Saida/entrada da VPC para internet |
| Route Table publica | `technova-public-rt` | Rota `0.0.0.0/0` para o IGW |
| Security Group API | `technova-api-sg` | Libera SSH 22 e API 3000 |
| Security Group DB | `technova-db-sg` | Libera PostgreSQL 5432 apenas na VPC |
| Key Pair | `technova-key` | Acesso SSH com chave publica local |
| IAM Role/Profile | `technova-ec2-s3-readonly-role` | Permissao S3 ReadOnly para a EC2 |
| EC2 | `technova-api-ec2` | Instancia `t2.micro` com API Node.js |

## Outputs

O projeto exporta `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `api_security_group_id`, `db_security_group_id`, `ec2_public_ip`, `api_url` e `ssh_command`.
