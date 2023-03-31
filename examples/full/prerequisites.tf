module "acm_certificate" {
  source = "infrablocks/acm-certificate/aws"
  version = "1.1.0"

  domain_name = "cdn-${var.component}-${var.deployment_identifier}.${var.domain_name}"
  domain_zone_id = var.public_zone_id
  subject_alternative_name_zone_id = var.public_zone_id

  providers = {
    aws.certificate = aws.cdn
    aws.domain_validation = aws.cdn
    aws.san_validation = aws.cdn
  }
}
