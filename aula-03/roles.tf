# Service role: EC2 assume esta role para acessar S3 sem access keys fixas.
resource "aws_iam_role" "ec2_role" {
  name = "${local.name_prefix}-ec2-role"
  path = "/technova/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEc2AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-ec2-role"
    Purpose = "EC2 access to TechNova app data"
  })
}

resource "aws_iam_policy" "ec2_s3_app_data" {
  name        = "${local.name_prefix}-ec2-s3-app-data"
  path        = "/technova/"
  description = "Permite que EC2 leia e grave dados nos buckets technova-app-data."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListAppDataBuckets"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::technova-app-data-*"]
      },
      {
        Sid    = "ReadWriteAppDataObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = ["arn:aws:s3:::technova-app-data-*/*"]
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-ec2-s3-app-data"
    Purpose = "EC2 S3 app data access"
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_app_data" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_app_data.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.name_prefix}-ec2-profile"
  path = "/technova/"
  role = aws_iam_role.ec2_role.name

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-ec2-profile"
    Purpose = "Instance profile for EC2 service role"
  })
}
