output "state_bucket_name" {
  description = "S3 bucket name to use in backend configuration"
  value       = aws_s3_bucket.tf_state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table name to use in backend configuration"
  value       = aws_dynamodb_table.tf_locks.name
}

output "backend_hcl_snippet" {
  description = "Copy values into infra/terraform/backend.hcl"
  value       = <<EOT
bucket         = "${aws_s3_bucket.tf_state.bucket}"
key            = "smart-hostel/main.tfstate"
region         = "${var.aws_region}"
dynamodb_table = "${aws_dynamodb_table.tf_locks.name}"
encrypt        = true
EOT
}
