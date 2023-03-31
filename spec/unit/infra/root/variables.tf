variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "distribution_origins" {
  type = list(object({
    id   = string
    path = optional(string)

    type = string

    domain_name = optional(string)

    bucket_name                   = optional(string)
    bucket_name_prefix            = optional(string)
    create_bucket                 = optional(bool)
    create_origin_access_identity = optional(bool)

    origin_shield = optional(object({
      enabled              = bool
      origin_shield_region = string
    }))

    s3_origin_config = optional(object({
      origin_access_identity = string
    }))

    custom_origin_config = optional(object({
      http_port                = string
      https_port               = string
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
    }))
  }))
}

variable "distribution_default_cache_behavior" {
  type = object({
    target_origin_id       = string
    cache_policy_id        = optional(string)
    cache_policy_name      = optional(string)
    allowed_methods        = optional(list(string))
    cached_methods         = optional(list(string))
    viewer_protocol_policy = optional(string)
    compress               = optional(bool)
  })
}

variable "distribution_viewer_certificate" {
  type        = object({
    acm_certificate_arn      = optional(string)
    ssl_support_method       = optional(string)
    minimum_protocol_version = optional(string)
  })
}
