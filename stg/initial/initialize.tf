# Account Alies
resource "aws_iam_account_alias" "alias" {
  account_alias = "${local.resource_prefix}-alias"
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

#Cloudtrail Enable
resource "aws_cloudtrail" "main" {
  name                          = "${local.resource_prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  s3_key_prefix                 = "cloudtrail"
}
