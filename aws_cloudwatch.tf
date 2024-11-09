
resource "aws_cloudwatch_log_group" "opensearch_logs" {
  name              = "/aws/opensearch/opensearch-domain-logs"
  retention_in_days = 5
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn
}


resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/OpenSearchService/domains/example-domain/application-logs"
  retention_in_days = 5
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_log_policy" {
  policy_name = "OpenSearchLogPolicy"
  policy_document = templatefile("${path.module}/policies/opensearch_log_policy.json", {
    log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
  })
}