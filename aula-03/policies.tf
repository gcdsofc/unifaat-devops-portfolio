# Developers: leitura em buckets TechNova, sem permissoes destrutivas.
resource "aws_iam_policy" "s3_read" {
  name        = "${local.name_prefix}-s3-read"
  path        = "/technova/"
  description = "Permite leitura em buckets S3 com prefixo technova."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListTechNovaBuckets"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::technova-*"]
      },
      {
        Sid      = "ReadTechNovaObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::technova-*/*"]
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-s3-read"
    Purpose = "Developers S3 read access"
  })
}

# Platform Engineering: operacao controlada de EC2 e leitura/escrita em S3.
resource "aws_iam_policy" "ec2_s3_full" {
  name        = "${local.name_prefix}-ec2-s3-full"
  path        = "/technova/"
  description = "Permite operacoes controladas de EC2 por tag e leitura/escrita em buckets TechNova."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DescribeEc2"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageTechNovaEc2ByTag"
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Project" = var.project_name
          }
        }
      },
      {
        Sid    = "ReadWriteTechNovaS3"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::technova-*",
          "arn:aws:s3:::technova-*/*"
        ]
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-ec2-s3-full"
    Purpose = "Platform Engineering EC2 and S3 operations"
  })
}

# Protecao extra: deny explicito prevalece sobre qualquer allow acidental.
resource "aws_iam_policy" "deny_destructive" {
  name        = "${local.name_prefix}-deny-destructive"
  path        = "/technova/"
  description = "Nega acoes destrutivas para reduzir risco operacional."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDeleteAndTerminate"
        Effect = "Deny"
        Action = [
          "*:Delete*",
          "*:Terminate*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-deny-destructive"
    Purpose = "Explicit deny for destructive actions"
  })
}

resource "aws_iam_group_policy_attachment" "developers_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_group_policy_attachment" "developers_deny_destructive" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}

resource "aws_iam_group_policy_attachment" "platform_ec2_s3" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.ec2_s3_full.arn
}
