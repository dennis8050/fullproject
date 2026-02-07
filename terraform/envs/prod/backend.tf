terraform {
  backend "s3" {
    bucket         = "terraformstatefile-prod"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"       # <-- must match the real bucket region
    # dynamodb_table = "terraform-lock"   # deprecated
    use_lockfile = true                    # new recommended way
  }
}
