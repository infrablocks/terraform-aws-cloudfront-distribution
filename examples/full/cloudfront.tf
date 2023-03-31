module "distribution" {
  source = "../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  distribution_origins = [
    {
      id                 = "website-content-${var.component}-${var.deployment_identifier}"
      type               = "s3"
      bucket_name_prefix = "website-content"
    },
    {
      id            = "website-images-${var.component}-${var.deployment_identifier}"
      type          = "s3"
      bucket_name   = "website-images-${var.component}-${var.deployment_identifier}"
      create_bucket = true
    },
    {
      id                   = "external-site-${var.component}-${var.deployment_identifier}"
      type                 = "custom"
      domain_name          = "www.google.com"
      custom_origin_config = {
        http_port              = "80"
        https_port             = "443"
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  ]

  distribution_default_cache_behavior = {
    target_origin_id  = "website-content-${var.component}-${var.deployment_identifier}"
    cache_policy_name = "Managed-CachingOptimized"
  }
  distribution_ordered_cache_behaviors = [
    {
      target_origin_id  = "external-site-${var.component}-${var.deployment_identifier}"
      path_pattern      = "/external/*"
      cache_policy_name = "Managed-CachingOptimized"
    },
    {
      target_origin_id = "website-images-${var.component}-${var.deployment_identifier}"
      path_pattern     = "/images/*"
      cache_policy_name = "Managed-CachingOptimized"
    }
  ]

  distribution_viewer_certificate = {
    acm_certificate_arn = module.acm_certificate.certificate_arn
  }

  dns = [
    {
      domain_name = "cdn-${var.component}-${var.deployment_identifier}.${var.domain_name}"
      records     = [
        {
          zone_id = var.public_zone_id
        },
        {
          zone_id = var.private_zone_id
        }
      ]
    }
  ]
}
