variable "component" {
  description = "The component this distribution will contain."
  type        = string
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
  type        = string
}

variable "distribution_price_class" {
  description = "The price class for this distribution. One of [\"PriceClass_All\", \"PriceClass_200\", \"PriceClass_100\"]. Defaults to \"PriceClass_All\"."
  type        = string
  default     = "PriceClass_All"
  nullable    = false
}

variable "distribution_http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are \"http1.1\", \"http2\", \"http2and3\" and \"http3\". Defaults to \"http2\"."
  type        = string
  default     = "http2"
  nullable    = false
}

variable "distribution_default_root_object" {
  description = "The object that you want CloudFront to return when an end user requests the root URL. Defaults to \"index.html\"."
  type        = string
  default     = "index.html"
}

variable "distribution_origins" {
  type = list(object({
    id   = string
    path = optional(string)

    type = string

    domain_name = optional(string)

    bucket_name                   = optional(string)
    bucket_name_prefix            = optional(string)
    create_bucket                 = optional(bool, false)
    create_origin_access_identity = optional(bool, true)

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
  description = "The default cache behavior for the distribution."
  type        = object({
    target_origin_id       = string
    cache_policy_id        = optional(string)
    cache_policy_name      = optional(string)
    allowed_methods        = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods         = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    viewer_protocol_policy = optional(string, "redirect-to-https")
    compress               = optional(bool, true)
  })
}

variable "distribution_ordered_cache_behaviors" {
  description = "The ordered cache behaviors for the distribution."
  type        = list(object({
    target_origin_id       = string
    path_pattern           = string
    cache_policy_id        = optional(string)
    cache_policy_name      = optional(string)
    allowed_methods        = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods         = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    viewer_protocol_policy = optional(string, "redirect-to-https")
    compress               = optional(bool, true)
  }))
  default  = []
  nullable = false
}

variable "distribution_viewer_certificate" {
  description = "The viewer certificate for the distribution."
  type        = object({
    acm_certificate_arn      = optional(string)
    ssl_support_method       = optional(string, "sni-only")
    minimum_protocol_version = optional(string, "TLSv1.2_2021")
  })
}

variable "distribution_custom_error_responses" {
  description = "A list of custom error responses for when the origin responds with a 4xx or 5xx HTTP status code."
  type        = list(object({
    error_code            = string
    error_caching_min_ttl = optional(string)
    response_code         = optional(string)
    response_page_path    = optional(string)
  }))
  default  = []
  nullable = false
}

variable "distribution_restrictions" {
  type = object({
    geo_restriction = object({
      restriction_type = optional(string, "none")
      locations        = optional(list(string), [])
    })
  })
  default = {
    geo_restriction = {
      restriction_type = "none",
      locations        = []
    }
  }
  nullable = false
}

variable "enable_distribution" {
  description = "Whether the distribution is enabled to accept end user requests for content. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "enable_distribution_ipv6" {
  description = "Whether IPv6 is enabled for the distribution. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "dns" {
  description = "Details of DNS records to point at the created distribution. Expects a domain_name, provided as an alias for the distribution, and used to create each record and a list of records to create. Each record object includes a zone_id referencing the hosted zone in which to create the record."
  type        = list(object({
    domain_name = string,
    records     = optional(list(object({ zone_id = string })), [])
  }))
  default  = []
  nullable = false
}

variable "tags" {
  description = "Additional tags to set on created resources."
  type        = map(string)
  default     = {}
}
