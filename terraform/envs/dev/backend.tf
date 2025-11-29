terraform {
  backend "s3" {
    bucket       = "terraformstatefile-dev"
    key          = "terraformstatefile/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
