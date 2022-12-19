terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

module "user_pool" {
  source = "../../"

  providers = {
    aws.certificate_provider = aws.use1
  }

  name_prefix      = "example"
  subdomain_name   = "example"
  hosted_zone_name = "auth.domain.example.com"

  tags = {
    environment = "example"
  }
}
