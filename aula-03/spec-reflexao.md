# Reflexao - Spec-Driven para IAM

## O que o Kiro acertou de primeira?

- Ajudou a organizar a estrutura em arquivos separados.
- Indicou a separacao entre users, groups, policies, attachments e roles.
- Sugeriu o uso de service role para EC2 em vez de access keys fixas.
- Reforcou a ideia de usar custom policies em vez de AWS managed policies amplas.

## O que precisou de correcao?

- Ajustei os nomes para usar o prefixo do RA `6325300`.
- Revisei as policies para evitar permissao ampla demais.
- Adicionei deny explicito para acoes destrutivas.
- Garanti outputs para users, groups, policy ARNs, role ARN e instance profile.
- Validei quais recursos realmente aceitam tags pelo schema do provider AWS.

## O checklist de validacao pegou algum problema?

Sim. O checklist ajudou a confirmar que:

- Nao existe `aws_iam_access_key` no codigo.
- As policies customizadas nao usam `Action = ["*"]`.
- As permissoes de EC2 usam condition por tag `Project = TechNova`.
- O role de EC2 usa trust policy com `ec2.amazonaws.com`.
- Arquivos de state, lock e tfvars estao ignorados no Git.

## Comparacao: se eu escrevesse manualmente, quanto tempo levaria?

Sem IA, eu gastaria mais tempo desenhando a estrutura e lembrando todos os recursos Terraform necessarios.
Com o apoio da IA, o rascunho inicial fica mais rapido, mas a validacao tecnica continua sendo obrigatoria.

## Em quais partes eu confiei no Kiro e em quais eu desconfiei?

Confiei mais na organizacao inicial dos arquivos e na lembranca dos componentes principais de IAM.
Desconfiei das permissoes, das actions das policies e do uso de `Resource = "*"`, porque seguranca exige revisao cuidadosa.

## O principio do menor privilegio foi respeitado na primeira geracao?

Parcialmente. A IA indicou custom policies, mas precisei revisar e limitar melhor as permissoes.
O resultado final ficou mais restrito: developers leem S3, platform engineering opera EC2 apenas com tag da TechNova, e a EC2 acessa somente buckets `technova-app-data-*`.
