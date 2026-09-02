# Aula 03 - Terraform + IAM | Gabriel Carneiro da Silva (6325300)

## Design da Estrutura IAM

Esta entrega cria a estrutura de seguranca da TechNova usando Terraform.
Usei o RA como prefixo em todos os nomes para evitar conflito com outros alunos na mesma conta AWS.

Foram criados dois grupos principais:

- `6325300-technova-developers`: grupo para desenvolvedores que precisam apenas consultar dados S3 da TechNova.
- `6325300-technova-platform-eng`: grupo para engenharia de plataforma, com permissoes operacionais de EC2 e leitura/escrita em S3.

Tambem foram criados tres usuarios individuais:

- `6325300-juliana-dev`: desenvolvedora senior, membro de developers.
- `6325300-rafael-platform`: membro de developers e platform engineering.
- `6325300-lucas-intern`: estagiario, membro de developers com acesso limitado.

A API/EC2 nao usa access key fixa. Para esse caso, criei a role `6325300-technova-ec2-role` com trust policy para `ec2.amazonaws.com`, uma policy especifica para buckets `technova-app-data-*` e um instance profile chamado `6325300-technova-ec2-profile`.

As tags obrigatorias foram aplicadas em todos os recursos que o provider AWS permite taguear: users, policies, role e instance profile.
Recursos de relacionamento, como memberships e policy attachments, nao possuem atributo `tags` no schema do provider.

## Principio do Menor Privilegio

O principio do menor privilegio significa conceder somente as permissoes necessarias para uma pessoa ou servico cumprir sua funcao.
Nesta entrega, apliquei isso de duas formas principais:

1. O grupo de developers recebe apenas `s3:ListBucket` e `s3:GetObject` em buckets com prefixo `technova-*`.
2. O grupo de platform engineering consegue iniciar, parar e reiniciar EC2 somente quando a instancia possui a tag `Project = TechNova`.

Se eu usasse `AmazonS3FullAccess` para todos, um dev ou estagiario poderia criar, alterar ou excluir buckets fora do escopo da TechNova.
Com custom policies, o acesso fica limitado, revisavel e alinhado com a responsabilidade de cada papel.

## Diagrama de Permissoes

```text
AWS Account Root (nunca usar diretamente)
|
|-- Group: 6325300-technova-developers
|   |-- Users: 6325300-juliana-dev, 6325300-rafael-platform, 6325300-lucas-intern
|   |-- Policy: 6325300-technova-s3-read
|   |   |-- Allows: s3:ListBucket, s3:GetObject em technova-*
|   |-- Policy: 6325300-technova-deny-destructive
|       |-- Denies: *:Delete*, *:Terminate*
|
|-- Group: 6325300-technova-platform-eng
|   |-- Users: 6325300-rafael-platform
|   |-- Policy: 6325300-technova-ec2-s3-full
|       |-- Allows: EC2 Describe, Start/Stop/Reboot por tag Project=TechNova
|       |-- Allows: S3 leitura/escrita em technova-*
|
|-- Role: 6325300-technova-ec2-role
    |-- Trust Policy: ec2.amazonaws.com pode assumir
    |-- Policy: 6325300-technova-ec2-s3-app-data
    |-- Instance Profile: 6325300-technova-ec2-profile
```

## Arquivos

| Arquivo | Funcao |
|---|---|
| `providers.tf` | Configura Terraform e provider AWS |
| `main.tf` | Cria users, groups e memberships |
| `policies.tf` | Cria custom policies e anexos aos groups |
| `roles.tf` | Cria role EC2, policy da role e instance profile |
| `variables.tf` | Centraliza variaveis e tags comuns |
| `outputs.tf` | Exibe users, groups, policies e role criados |
| `terraform-plan-output.txt` | Evidencia do plano Terraform |
| `spec-reflexao.md` | Reflexao sobre uso de IA/Spec-Driven para IAM |
| `.gitignore` | Impede versionamento de state, lock e tfvars |

## Comandos Utilizados

```bash
terraform fmt
terraform init
terraform validate
terraform plan
```

Eu nao executei `terraform apply` nesta entrega, porque o TF pede a evidencia do plano.
Em um ambiente real ou laboratorio com aplicacao, o proximo passo seria aplicar, validar na AWS e depois executar `terraform destroy` para limpar os recursos.

## Reflexao

Criar IAM pelo Console AWS e rapido no primeiro clique, mas e dificil de auditar e reproduzir.
Com Terraform, toda permissao fica escrita em arquivo, passa por Git, pode ser revisada em Pull Request e recriada em outra conta ou ambiente.

Para seguranca, Terraform deixa claro quem recebe qual policy e por qual motivo.
Isso reduz o risco de credenciais root compartilhadas, permissoes excessivas e mudancas feitas sem historico.
