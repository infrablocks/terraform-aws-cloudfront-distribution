resource "aws_cloudfront_distribution" "distribution" {
  enabled         = var.enable_distribution
  is_ipv6_enabled = var.enable_distribution_ipv6
  price_class     = var.distribution_price_class
  http_version    = var.distribution_http_version

  dynamic "origin" {
    for_each = toset(var.distribution_origins)

    content {
      origin_id   = origin.value.id
      origin_path = origin.value.path

      domain_name = origin.value.domain_name == null ? try(aws_s3_bucket.origin_bucket[origin.value.id].bucket_regional_domain_name, null) : origin.value.domain_name

      dynamic "origin_shield" {
        for_each = origin.value.origin_shield != null ? toset([origin.value.origin_shield]) : toset([])

        content {
          enabled              = try(origin_shield.value.enabled, null)
          origin_shield_region = try(origin_shield.value.origin_shield_region, null)
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.type == "s3" && (try(origin.value.s3_origin_config.origin_access_identity, null) != null || try(aws_cloudfront_origin_access_identity.origin_bucket_access_identity[origin.value.id].cloudfront_access_identity_path, null) != null) ? toset([origin.value.s3_origin_config]) : toset([])

        content {
          origin_access_identity = try(s3_origin_config.value.origin_access_identity, null) == null ? try(aws_cloudfront_origin_access_identity.origin_bucket_access_identity[origin.value.id].cloudfront_access_identity_path, null) : try(s3_origin_config.value.origin_access_identity, null)
        }
      }

      dynamic "custom_origin_config" {
        for_each = (origin.value.type == "custom" && origin.value.custom_origin_config != null) ? toset([origin.value.custom_origin_config]) : toset([])

        content {
          http_port                = try(custom_origin_config.value.http_port, null)
          https_port               = try(custom_origin_config.value.https_port, null)
          origin_protocol_policy   = try(custom_origin_config.value.origin_protocol_policy, null)
          origin_ssl_protocols     = try(custom_origin_config.value.origin_ssl_protocols, null)
          origin_keepalive_timeout = try(custom_origin_config.value.origin_keepalive_timeout, null)
          origin_read_timeout      = try(custom_origin_config.value.origin_read_timeout, null)
        }
      }
    }
  }

  default_root_object = var.distribution_default_root_object

  default_cache_behavior {
    target_origin_id = var.distribution_default_cache_behavior.target_origin_id

    allowed_methods = var.distribution_default_cache_behavior.allowed_methods
    cached_methods  = var.distribution_default_cache_behavior.cached_methods

    cache_policy_id = var.distribution_default_cache_behavior.cache_policy_id == null ? try(data.aws_cloudfront_cache_policy.default_behavior_cache_policy[var.distribution_default_cache_behavior.cache_policy_name].id, null) : var.distribution_default_cache_behavior.cache_policy_id

    viewer_protocol_policy = var.distribution_default_cache_behavior.viewer_protocol_policy
    compress               = var.distribution_default_cache_behavior.compress
  }

  dynamic "ordered_cache_behavior" {
    for_each = toset(var.distribution_ordered_cache_behaviors)

    content {
      target_origin_id = ordered_cache_behavior.value.target_origin_id
      path_pattern     = ordered_cache_behavior.value.path_pattern

      allowed_methods = ordered_cache_behavior.value.allowed_methods
      cached_methods  = ordered_cache_behavior.value.cached_methods

      cache_policy_id = ordered_cache_behavior.value.cache_policy_id == null ? try(data.aws_cloudfront_cache_policy.ordered_behavior_cache_policy[ordered_cache_behavior.value.target_origin_id].id, null) : ordered_cache_behavior.value.cache_policy_id

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      compress               = ordered_cache_behavior.value.compress
    }
  }

  dynamic "custom_error_response" {
    for_each = toset(var.distribution_custom_error_responses)

    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.distribution_restrictions.geo_restriction.restriction_type
      locations        = var.distribution_restrictions.geo_restriction.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.distribution_viewer_certificate.acm_certificate_arn
    ssl_support_method       = var.distribution_viewer_certificate.ssl_support_method
    minimum_protocol_version = var.distribution_viewer_certificate.minimum_protocol_version
  }

  aliases = [for dns_entry in var.dns : dns_entry.domain_name]

  tags = local.resolved_tags
}
