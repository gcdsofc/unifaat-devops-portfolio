data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  count = var.use_lab_instance_profile ? 0 : 1

  name               = "${local.name_prefix}-ec2-s3-readonly-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-s3-readonly-role"
  })
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  count = var.use_lab_instance_profile ? 0 : 1

  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.use_lab_instance_profile ? 0 : 1

  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2[0].name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-profile"
  })
}
