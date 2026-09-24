# Aula 06 - Terraform Modules

Biblioteca de modulos Terraform reutilizaveis para criar ambientes completos da TechNova com VPC, Security Groups, EC2 e RDS.

O objetivo desta aula e sair de codigo duplicado para uma arquitetura DRY: cada modulo encapsula uma responsabilidade e os ambientes `dev` e `staging` apenas passam valores diferentes.

## Arquitetura dos modulos

```text
modules/vpc
  outputs: vpc_id, public_subnet_ids, private_subnet_ids
      |
      vpc_id
      v
modules/security-group
  outputs: sg_id
      |
      +--> modules/ec2 usa public_subnet_ids[0] + api_sg.sg_id
      |
      +--> modules/rds usa private_subnet_ids + rds_sg.sg_id
```

Ordem logica de criacao:

1. `vpc` cria a rede base e expõe `vpc_id`, `public_subnet_ids` e `private_subnet_ids`.
2. `security-group` usa `vpc_id` para criar as regras da API e do RDS.
3. `ec2` usa uma subnet publica e o Security Group da API.
4. `rds` usa as subnets privadas e o Security Group do banco.

## Estrutura

```text
aula-06/
|-- environments/
|   |-- dev/
|   `-- staging/
`-- modules/
    |-- vpc/
    |-- security-group/
    |-- ec2/
    `-- rds/
```

## Modulos disponiveis

| Modulo | Descricao | Principais inputs | Principais outputs |
|---|---|---|---|
| `vpc` | Cria VPC, subnets dinamicas, IGW e Route Table publica | `vpc_cidr`, `subnets`, `project_name`, `environment` | `vpc_id`, `public_subnet_ids`, `private_subnet_ids` |
| `security-group` | Cria SG generico com lista de regras ingress | `name`, `vpc_id`, `ingress_rules` | `sg_id` |
| `ec2` | Cria EC2 configuravel | `ami_id`, `subnet_id`, `security_group_ids`, `key_name` | `instance_id`, `public_ip`, `private_ip` |
| `rds` | Cria DB Subnet Group e RDS PostgreSQL | `subnet_ids`, `security_group_ids`, `db_name`, `db_username`, `db_password` | `db_endpoint`, `db_name`, `db_port` |

## Detalhamento dos modulos

### `modules/vpc`

Cria uma VPC com DNS habilitado, subnets dinamicas via `for_each`, Internet Gateway e associacao de Route Table para as subnets publicas.

| Input | Tipo | Obrigatorio | Descricao |
|---|---|---|---|
| `vpc_cidr` | `string` | Sim | CIDR principal da VPC |
| `project_name` | `string` | Sim | Nome usado nas tags |
| `environment` | `string` | Sim | Ambiente: dev, staging ou prod |
| `subnets` | `map(object)` | Sim | Mapa com `cidr`, `az` e `type` |
| `tags` | `map(string)` | Nao | Tags adicionais |

| Output | Descricao |
|---|---|
| `vpc_id` | ID da VPC |
| `public_subnet_ids` | Lista de subnets publicas |
| `private_subnet_ids` | Lista de subnets privadas |
| `subnet_id_map` | Mapa com nome da subnet e ID |

### `modules/security-group`

Modulo generico de Security Group. A mesma implementacao cria o SG da API e o SG do RDS mudando apenas a lista de regras.

| Input | Tipo | Obrigatorio | Descricao |
|---|---|---|---|
| `name` | `string` | Sim | Nome do Security Group |
| `description` | `string` | Nao | Descricao do SG |
| `vpc_id` | `string` | Sim | VPC onde o SG sera criado |
| `ingress_rules` | `list(object)` | Nao | Regras de entrada |
| `project_name` | `string` | Sim | Nome usado nas tags |
| `environment` | `string` | Sim | Ambiente |
| `tags` | `map(string)` | Nao | Tags adicionais |

| Output | Descricao |
|---|---|
| `sg_id` | ID do Security Group |

### `modules/ec2`

Cria uma instancia EC2 configuravel, recebendo AMI, tipo, subnet, Security Groups, Key Pair e `user_data` opcional.

| Input | Tipo | Obrigatorio | Descricao |
|---|---|---|---|
| `instance_name` | `string` | Sim | Nome da instancia |
| `instance_type` | `string` | Nao | Tipo da instancia, default `t2.micro` |
| `ami_id` | `string` | Sim | AMI usada pela EC2 |
| `subnet_id` | `string` | Sim | Subnet onde a EC2 sera criada |
| `security_group_ids` | `list(string)` | Sim | Security Groups associados |
| `key_name` | `string` | Sim | Key Pair para SSH |
| `user_data` | `string` | Nao | Script de inicializacao |

| Output | Descricao |
|---|---|
| `instance_id` | ID da instancia |
| `public_ip` | IP publico |
| `private_ip` | IP privado |

### `modules/rds`

Cria DB Subnet Group com subnets privadas e RDS PostgreSQL 15 usando configuracoes adequadas para laboratorio.

| Input | Tipo | Obrigatorio | Descricao |
|---|---|---|---|
| `db_name` | `string` | Sim | Nome do database |
| `db_username` | `string` | Sim | Usuario master |
| `db_password` | `string` | Sim | Senha master marcada como sensivel |
| `subnet_ids` | `list(string)` | Sim | Subnets privadas para o DB Subnet Group |
| `security_group_ids` | `list(string)` | Sim | Security Groups do RDS |
| `instance_class` | `string` | Nao | Default `db.t3.micro` |
| `allocated_storage` | `number` | Nao | Default `20` GB |

| Output | Descricao |
|---|---|
| `db_endpoint` | Endpoint do RDS |
| `db_name` | Nome do database |
| `db_port` | Porta do RDS |

## Como validar

Ambiente dev:

```bash
cd environments/dev
terraform init
terraform validate
terraform plan
```

Ambiente staging:

```bash
cd ../staging
terraform init
terraform validate
terraform plan
```

## Como criar um novo ambiente

Crie uma nova pasta em `environments/`, por exemplo `prod/`, copie a estrutura de `dev/` e altere:

- `environment`
- `vpc_cidr`
- mapa `subnets`
- `db_name`
- prefixos e nomes dos recursos

Os modulos continuam iguais; apenas as variaveis mudam.

Exemplo de chamada do modulo VPC:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr     = "10.2.0.0/16"
  project_name = "technova"
  environment  = "prod"

  subnets = {
    public-1  = { cidr = "10.2.1.0/24", az = "us-east-1a", type = "public" }
    public-2  = { cidr = "10.2.2.0/24", az = "us-east-1b", type = "public" }
    private-1 = { cidr = "10.2.3.0/24", az = "us-east-1a", type = "private" }
    private-2 = { cidr = "10.2.4.0/24", az = "us-east-1b", type = "private" }
  }
}
```

## Pre-requisitos

- Terraform `>= 1.6.0`
- AWS CLI configurado com credenciais do AWS Academy Learner Lab
- Key Pair existente ou chave publica para criar Key Pair
- Executar `terraform destroy` se fizer `apply`

## Observacao sobre senha do banco

A senha nos ambientes e um valor de laboratorio para permitir `terraform plan`. Em uso real, informe `db_password` por `terraform.tfvars` local ignorado pelo Git ou por variavel de ambiente `TF_VAR_db_password`.
