variable "env" {}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "terraformstatefile-${var.env}"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "locks" {
  name         = "terraform-locks-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
