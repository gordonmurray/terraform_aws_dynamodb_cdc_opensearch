resource "aws_opensearch_domain" "example_domain" {
  domain_name    = "example-domain"
  engine_version = "OpenSearch_2.13"

  # Cluster configuration
  cluster_config {
    instance_type          = "t3.small.search"
    instance_count         = 3
    zone_awareness_enabled = false
  }

  # EBS storage
  ebs_options {
    ebs_enabled = true
    volume_size = 20 # Size in GB
    volume_type = "gp2"
  }

  # Access policies
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "es:*"
        Resource  = "arn:aws:es:${var.region}:${var.aws_account_id}:domain/example-domain/*"
      }
    ]
  })

  # VPC configuration
  vpc_options {
    subnet_ids         = [element(var.subnets, 0)] # Selects the first subnet in the list
    security_group_ids = [aws_security_group.opensearch.id]
  }

  # Logging
  log_publishing_options {
    enabled                  = true
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
  }



  tags = {
    Name        = "example-domain"
    Environment = "production"
  }
}

