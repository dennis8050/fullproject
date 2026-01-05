variable "env" {}

provider "aws" {
  region = "us-east-1"

}

 #------------------------------
 #S3 Bucket (Terraform Backend)
 #------------------------------
resource "aws_s3_bucket" "state" {
 # bucket = "terraformstatefile-${var.env}"
}

 #S3 Versioning (NEW REQUIRED RESOURCE)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

 #(Recommended) Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# (Recommended) Block Public Access
resource "aws_s3_bucket_public_access_block" "state_block" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------
# DynamoDB Lock Table
# ------------------------------
resource "aws_dynamodb_table" "locks" {
  name         = "terraform-locks-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
