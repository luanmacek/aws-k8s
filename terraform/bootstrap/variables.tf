variable "aws_region" {
  description = "AWS region where backend resources will be created."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_prefix" {
  description = "Prefix for the Terraform state S3 bucket."
  type        = string
  default     = "terraform-state-bucket"
}

variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table used for state locking."
  type        = string
  default     = "terraform-state-lock"
}
