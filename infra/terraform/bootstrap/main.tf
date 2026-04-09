data "aws_caller_identity" "current" {}

locals {
  computed_bucket_name = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  bucket_name          = var.state_bucket_name != "" ? var.state_bucket_name : local.computed_bucket_name
}

resource "aws_s3_bucket" "tf_state" {
  bucket = local.bucket_name

  tags = {
    Name    = local.bucket_name
    Project = var.project_name
    Purpose = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.lock_table_name
    Project = var.project_name
    Purpose = "terraform-state-locking"
  }
}
