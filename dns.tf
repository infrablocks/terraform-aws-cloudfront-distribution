locals {
  dns_records = merge([
    for entry in var.dns: {
        for record in entry.records:
          "${entry.domain_name}-${record.zone_id}" => {
            domain_name: entry.domain_name
            zone_id: record.zone_id
          }
    }
  ]...)
}

resource "aws_route53_record" "cdn_alias" {
  for_each = local.dns_records

  zone_id = each.value.zone_id
  name = each.value.domain_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
