output "distribution_id" {
  value = module.distribution.distribution_id
}

output "distribution_arn" {
  value = module.distribution.distribution_arn
}

output "distribution_domain_name" {
  value = module.distribution.distribution_domain_name
}

output "distribution_hosted_zone_id" {
  value = module.distribution.distribution_hosted_zone_id
}

output "origin_bucket_access_identity_ids" {
  value = module.distribution.origin_bucket_access_identity_ids
}

output "origin_bucket_access_identity_cloudfront_access_identity_paths" {
  value = module.distribution.origin_bucket_access_identity_cloudfront_access_identity_paths
}
