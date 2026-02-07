terraform {
  backend "s3" {
    bucket       = "terraformstatefile-prod"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
