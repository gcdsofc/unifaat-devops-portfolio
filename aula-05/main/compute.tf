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
}

resource "aws_key_pair" "technova" {
  key_name   = "${local.name_prefix}-key"
  public_key = local.ssh_public_key

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-key"
  })
}

resource "aws_instance" "api" {
  ami                    = local.amazon_linux_2023_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.technova.key_name
  user_data              = file("${path.module}/user_data.sh")
  iam_instance_profile   = var.use_lab_instance_profile ? var.lab_instance_profile_name : null

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2"
  })
}
