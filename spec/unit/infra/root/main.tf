data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "distribution" {
  source = "../../../.."

  component = var.component
  deployment_identifier = var.deployment_identifier

  distribution_origins = var.distribution_origins

  distribution_default_cache_behavior = var.distribution_default_cache_behavior

  distribution_viewer_certificate = var.distribution_viewer_certificate
}
