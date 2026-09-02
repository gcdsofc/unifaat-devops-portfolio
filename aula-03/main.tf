# Groups com responsabilidades separadas.
resource "aws_iam_group" "developers" {
  name = "${local.name_prefix}-developers"
  path = "/technova/"
}

resource "aws_iam_group" "platform_eng" {
  name = "${local.name_prefix}-platform-eng"
  path = "/technova/"
}

# Users individuais. Nenhuma access key e criada neste exercicio.
resource "aws_iam_user" "juliana_dev" {
  name          = "${var.ra}-juliana-dev"
  path          = "/technova/"
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.ra}-juliana-dev"
    Team = "Development"
    Role = "Senior Developer"
  })
}

resource "aws_iam_user" "rafael_platform" {
  name          = "${var.ra}-rafael-platform"
  path          = "/technova/"
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.ra}-rafael-platform"
    Team = "Platform Engineering"
    Role = "Platform Engineer"
  })
}

resource "aws_iam_user" "lucas_intern" {
  name          = "${var.ra}-lucas-intern"
  path          = "/technova/"
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.ra}-lucas-intern"
    Team = "Development"
    Role = "Intern"
  })
}

# Memberships: Rafael participa de development e platform engineering.
resource "aws_iam_group_membership" "developers" {
  name = "${local.name_prefix}-developers-membership"

  users = [
    aws_iam_user.juliana_dev.name,
    aws_iam_user.rafael_platform.name,
    aws_iam_user.lucas_intern.name
  ]

  group = aws_iam_group.developers.name
}

resource "aws_iam_group_membership" "platform_eng" {
  name = "${local.name_prefix}-platform-eng-membership"

  users = [
    aws_iam_user.rafael_platform.name
  ]

  group = aws_iam_group.platform_eng.name
}
