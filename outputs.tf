output "distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.distribution.arn
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.distribution.hosted_zone_id
}

output "origin_bucket_access_identity_ids" {
  value = try(aws_cloudfront_origin_access_identity.origin_bucket_access_identity[*].id, [])
}

output "origin_bucket_access_identity_cloudfront_access_identity_paths" {
  value = try(aws_cloudfront_origin_access_identity.origin_bucket_access_identity[*].cloudfront_access_identity_path, [])
}
