# Reflexao - Spec-Driven para EC2 na VPC

## O que a abordagem com IA acertou de primeira?

- Separou a infraestrutura em arquivos pequenos por responsabilidade: rede, seguranca, IAM, computacao, variaveis e outputs.
- Manteve a VPC com subnets publicas e privadas em duas AZs.
- Incluiu Security Groups separados para API e banco.
- Criou User Data em arquivo separado para instalar Node.js 18, Git e iniciar a API na porta 3000.
- Incluiu outputs importantes para validar a infraestrutura depois do apply.

## O que precisou de correcao?

- Foi necessario tratar a diferenca entre o TF e o AWS Academy: o TF pede IAM Role propria, mas o Learner Lab pode bloquear criacao de IAM. Por isso foi criada a variavel `use_lab_instance_profile`.
- A conta local usada para gerar o plan nao tinha permissao `ec2:DescribeImages`, entao foi adicionada a variavel `ami_id_override` para permitir o plan em ambiente limitado, mantendo o data source como padrao.
- A chave SSH nao deve entrar no repositorio, entao o projeto usa `public_key_path` ou `ssh_public_key`.

## O user_data.sh gerado funcionou sem ajustes?

O script foi revisado e validado como arquivo Terraform, mas a execucao completa depende de `terraform apply` em ambiente AWS com EC2 criada. Ele instala Git, Node.js 18, prepara uma API Express simplificada e registra um servico `systemd` para iniciar automaticamente.

## O checklist pegou algum problema de seguranca?

Sim. O principal ponto e a porta 22 aberta para `0.0.0.0/0`, que atende ao enunciado do TF, mas em producao deveria ser limitada ao IP dos administradores ou substituida por acesso via bastion/SSM. O banco ficou protegido em subnet privada e com porta 5432 liberada apenas para `10.0.0.0/16`.

## Comparacao com o Lab 1 manual: qual abordagem foi mais rapida?

A abordagem spec-driven foi mais rapida para criar a estrutura completa, principalmente por permitir revisar requisitos antes de escrever tudo. O lab manual ajuda mais no entendimento de cada recurso e dependencia.

## Em quais partes o Spec-Driven brilhou e em quais foi limitado?

Brilhou na organizacao dos arquivos, na repeticao segura de tags e na criacao dos recursos dependentes. Foi limitado nas diferencas de permissao do ambiente AWS Academy e na necessidade de validar evidencias reais apenas depois do apply.
