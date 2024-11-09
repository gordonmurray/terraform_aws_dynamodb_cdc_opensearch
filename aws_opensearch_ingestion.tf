# Interpolate variables into pipeline.yaml using templatefile
locals {
  pipeline_config = templatefile("pipeline.yaml.tpl", {
    dynamodb_stream_arn = aws_dynamodb_table.users_table.stream_arn,
    opensearch_endpoint = aws_opensearch_domain.example_domain.endpoint,
    s3_bucket_name      = aws_s3_bucket.backups.bucket,
    iam_role_arn        = aws_iam_role.opensearch_access_role.arn
    region              = var.region
  })
}

resource "awscc_logs_log_group" "log_group" {
  log_group_name = "/aws/vendedlogs/OpenSearchIngestion/opensearch-pipeline/audit-logs"
}

resource "awscc_osis_pipeline" "opensearch_pipeline" {
  pipeline_name = "pipeline"
  min_units     = 2
  max_units     = 4
  vpc_options = {
    security_group_ids      = [aws_security_group.opensearch.id]
    subnet_ids              = var.subnets
    vpc_endpoint_management = "SERVICE"
    vpc_attachment_options = {
      attach_to_vpc = false
      cidr_block    = "10.0.0.0/24"
    }
  }

  # Use the local variable with the interpolated YAML content
  pipeline_configuration_body = local.pipeline_config

  log_publishing_options = {
    is_logging_enabled = true
    cloudwatch_log_destination = {
      log_group = awscc_logs_log_group.log_group.log_group_name
    }
  }
}
