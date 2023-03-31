data "aws_cloudfront_cache_policy" "default_behavior_cache_policy" {
  for_each = var.distribution_default_cache_behavior.cache_policy_name == null ? toset([]) : toset([var.distribution_default_cache_behavior.cache_policy_name])

  name = each.value
}

data "aws_cloudfront_cache_policy" "ordered_behavior_cache_policy" {
  for_each = {
    for behavior in var.distribution_ordered_cache_behaviors:
        behavior.target_origin_id => behavior.cache_policy_name
        if behavior.cache_policy_name != null
  }

  name = each.value
}
