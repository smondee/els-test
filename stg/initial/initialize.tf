# Account Alies
resource "aws_iam_account_alias" "alias" {
  account_alias = "${local.resource_prefix_short}"
}

# IAM Group
resource "aws_iam_group" "dev" {
  name = "test-kanri-ope"
  path = "/"
}

# IAM Password Policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

#Cross Account Role 

locals {
  administrator_policy_attachment = {
    AdministratorAccess      = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
  poweruser_policy_attachment = {
    PowerUserAccess      = "arn:aws:iam::aws:policy/PowerUserAccess"
    Billing      = "arn:aws:iam::aws:policy/Billing"
  }
  readonly_policy_attachment = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    Billing      = "arn:aws:iam::aws:policy/Billing"
  }
}

#AdministratorAccess
resource "aws_iam_role" "administrator_switch_role" {
  name = "${local.resource_prefix_short}-FullAccess-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::884821112553:root",
            ]
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
  tags = {
    Name = "${local.resource_prefix_short}-FullAccess-role"
  }
}

resource "aws_iam_role_policy_attachment" "administrator_switch_role" {
  for_each   = local.administrator_policy_attachment
  role       = aws_iam_role.administrator_switch_role.name
  policy_arn = each.value
}

#PowerUser
resource "aws_iam_role" "poweruser_switch_role" {
  name = "${local.resource_prefix_short}-PowerUser-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::884821112553:root",
            ]
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
  tags = {
    Name = "${local.resource_prefix_short}-PowerUser-role"
  }
}

resource "aws_iam_role_policy_attachment" "poweruser_switch_role" {
  for_each   = local.poweruser_policy_attachment
  role       = aws_iam_role.poweruser_switch_role.name
  policy_arn = each.value
}


resource "aws_iam_role" "readonly_switch_role" {
  name = "${local.resource_prefix_short}-ReadOnly-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::884821112553:root",
            ]
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
  tags = {
    Name = "${local.resource_prefix_short}-ReadOnly-role"
  }
}

resource "aws_iam_role_policy_attachment" "readonly_switch_role" {
  for_each   = local.readonly_policy_attachment
  role       = aws_iam_role.readonly_switch_role.name
  policy_arn = each.value
}
