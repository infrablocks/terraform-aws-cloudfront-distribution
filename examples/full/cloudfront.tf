module "distribution" {
  source = "../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier
}
