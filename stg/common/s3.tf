data "aws_caller_identity" "current" {}
data "aws_canonical_user_id" "current_user" {}
data "aws_region" "current" {}

locals {
  s3_bucket = {
    server_log        = "${local.resource_prefix}-server-log"
    outer_elb_log     = "${local.resource_prefix}-outer-vpc-log"
    inner_elb_log     = "${local.resource_prefix}-inner-vpc-log"
  }
}
resource "aws_s3_bucket" "bucket" {
  for_each = local.s3_bucket

  bucket = each.value
}
resource "aws_s3_bucket_acl" "bucket" {
  for_each = local.s3_bucket

  bucket = aws_s3_bucket.bucket[each.key].id
  acl    = "private"
}
/*
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...

    status = "Enabled"
  }
}
*/

/* bucket_policy */
resource "aws_s3_bucket_policy" "outer_elb_log" {
  bucket = aws_s3_bucket.bucket["outer_elb_log"].id
  policy = data.aws_iam_policy_document.outer_elb_log.json
}
data "aws_elb_service_account" "outer_elb_log" {}
data "aws_iam_policy_document" "outer_elb_log" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.resource_prefix}-outer-elb-log/*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        data.aws_elb_service_account.outer-elb_log.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "inner_elb_log" {
  bucket = aws_s3_bucket.bucket["inner_elb_log"].id
  policy = data.aws_iam_policy_document.inner_elb_log.json
}
data "aws_elb_service_account" "inner_elb_log" {}
data "aws_iam_policy_document" "inner_elb_log" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.resource_prefix}-inner-elb-log/*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        data.aws_elb_service_account.inner-elb_log.arn
      ]
    }
  }
}

# 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  for_each = local.s3_bucket

  bucket = each.value
  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

