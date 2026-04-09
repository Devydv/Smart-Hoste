variable "aws_region" {
  description = "AWS region for Terraform backend resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project prefix for naming backend resources"
  type        = string
  default     = "smart-hostel"
}

variable "state_bucket_name" {
  description = "Optional explicit S3 bucket name for state. Leave empty to auto-generate."
  type        = string
  default     = ""
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "smart-hostel-tf-locks"
}
