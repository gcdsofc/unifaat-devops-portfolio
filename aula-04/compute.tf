data "aws_ami" "amazon_linux_2023" {
  count = trimspace(var.ami_id_override) == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "technova" {
  key_name   = "${local.name_prefix}-key"
  public_key = local.ssh_public_key

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-key"
  })
}

resource "aws_instance" "api" {
  ami                         = local.amazon_linux_2023_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public["public_a"].id
  vpc_security_group_ids      = [aws_security_group.api.id]
  key_name                    = aws_key_pair.technova.key_name
  iam_instance_profile        = local.ec2_instance_profile_name
  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-api-ec2"
  })

  depends_on = [
    aws_internet_gateway.main,
    aws_iam_role_policy_attachment.s3_readonly
  ]
}
