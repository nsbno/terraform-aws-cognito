terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.65.0"

      configuration_aliases = [aws.certificate_provider]
    }
  }
}

###############################
#
# AWS Cognito User Pool
#
###############################


resource "aws_cognito_user_pool" "this" {
  name = var.name_prefix

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  deletion_protection = var.deletion_protection ? "ACTIVE" : "INACTVE"

  tags = var.tags
}

###############################
#
# Custom domain
#
###############################


resource "aws_cognito_user_pool_domain" "this" {
  user_pool_id    = aws_cognito_user_pool.this.id
  domain          = "${var.subdomain_name}.${var.hosted_zone_name}"
  certificate_arn = module.certificate.arn
}

data "aws_route53_zone" "this" {
  name = var.hosted_zone_name
}

resource "aws_route53_record" "this" {
  name    = aws_cognito_user_pool_domain.this.domain
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.this.cloudfront_distribution_arn
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

###############################
#
# Certificate for custom domain
#
###############################

module "certificate" {
  providers = {
    aws = aws.certificate_provider
  }
  source           = "github.com/nsbno/terraform-aws-acm-certificate?ref=e7988c1"
  hosted_zone_name = var.hosted_zone_name
  domain_name      = "${var.subdomain_name}.${var.hosted_zone_name}"

  tags = var.tags
}
