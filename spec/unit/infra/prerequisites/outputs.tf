output "certificate_arn" {
  value = module.acm_certificate.certificate_arn
}

output "certificate_domain_name" {
  value = local.certificate_domain_name
}
