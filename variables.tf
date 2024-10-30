
variable "aws_account_id" {
  type        = string
  description = "Your AWS account ID"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to deploy into"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy to"
  default     = "eu-west-1"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "default_tag" {
  type        = string
  description = "A default tag to add to everything"
  default     = "terraform_aws_dynamodb_cdc_opensearch"
}
