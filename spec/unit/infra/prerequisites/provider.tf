provider "aws" {
  region  = var.region
}

provider "aws" {
  alias = "cdn"
  region = "us-east-1"
}
