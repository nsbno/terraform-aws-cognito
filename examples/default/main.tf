module "user_pool" {
  source           = "../../"
  name_prefix      = "example"
  subdomain_name   = "example"
  hosted_zone_name = "auth.domain.example.com"

  tags = {
    environment = "example"
  }
}
