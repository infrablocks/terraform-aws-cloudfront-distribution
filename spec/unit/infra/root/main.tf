data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "distribution" {
  source = "../../../.."

  region = var.region

  component = var.component
  deployment_identifier = var.deployment_identifier
}
