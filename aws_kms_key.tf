resource "aws_kms_key" "cloudwatch_logs" {
  description             = "KMS key for OpenSearch logs"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/kms_policy.json", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_kms_key" "dynamo_db_kms" {
  description             = "KMS key for DynamoDB table encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/dynamodb_kms_policy.json", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })
}
