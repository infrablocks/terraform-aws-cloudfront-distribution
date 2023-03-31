locals {
  bucket_origins = merge(
    {
      for origin in var.distribution_origins:
        origin.id => merge(origin, {
          bucket_name: "${origin.bucket_name_prefix}-${var.component}-${var.deployment_identifier}"
        }) if origin.bucket_name_prefix != null
    },
    {
      for origin in var.distribution_origins:
        origin.id => origin if (origin.bucket_name != null && origin.create_bucket == true)
    }
  )
}

resource "aws_cloudfront_origin_access_identity" "origin_bucket_access_identity" {
  for_each = local.bucket_origins

  comment = each.value.bucket_name
}

data "aws_iam_policy_document" "origin_bucket_policy" {
  for_each = local.bucket_origins

  statement {
    sid = "CloudFrontReadAccess"

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.origin_bucket_access_identity[each.key].iam_arn]
      type = "AWS"
    }

    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::${each.value.bucket_name}/*"]
  }
}

resource "aws_s3_bucket" "origin_bucket" {
  for_each = local.bucket_origins
  bucket = each.value.bucket_name
  tags = local.resolved_tags
}

resource "aws_s3_bucket_policy" "origin_bucket_policy" {
  for_each = local.bucket_origins
  bucket = aws_s3_bucket.origin_bucket[each.key].id
  policy = data.aws_iam_policy_document.origin_bucket_policy[each.key].json
}
