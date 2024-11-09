resource "aws_iam_role" "opensearch_access_role" {
  name = "OpenSearchDDBAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "opensearchservice.amazonaws.com",
            "osis-pipelines.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ddb_to_opensearch_policy" {
  name = "DynamoDBToOpenSearchPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:*",
          "opensearch:*",
          "s3:PutObject",
          "s3:GetObject",
          "dynamodb:GetShardIterator",
          "es:ESHttpPost",
          "es:ESHttpGet",
          "es:DescribeDomain",
          "dynamodb:DescribeStream",
          "s3:ListBucket",
          "es:ESHttpPut",
          "dynamodb:GetRecords",
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.users_table.stream_arn,
          aws_dynamodb_table.products_table.stream_arn,
          "${aws_opensearch_domain.example_domain.arn}/*",
          aws_s3_bucket.backups.arn,
          "${aws_s3_bucket.backups.arn}/*",
        ]
      },
      {
        Action = [
          "es:DeleteOutboundConnection",
          "es:UpdateVpcEndpoint",
          "es:DeletePackage",
          "es:ListVpcEndpoints",
          "es:ListVpcEndpointsForDomain",
          "es:ListElasticsearchInstanceTypeDetails",
          "es:ListDomainsForPackage",
          "es:ListInstanceTypeDetails",
          "es:AuthorizeVpcEndpointAccess",
          "es:AcceptInboundConnection",
          "es:DeleteElasticsearchServiceRole",
          "es:DescribeInboundConnections",
          "es:DescribeOutboundConnections",
          "es:DescribeReservedInstances",
          "es:AcceptInboundCrossClusterSearchConnection",
          "es:DescribeReservedInstanceOfferings",
          "es:DescribeInstanceTypeLimits",
          "es:DescribeVpcEndpoints",
          "es:ListVpcEndpointAccess",
          "es:DeleteInboundCrossClusterSearchConnection",
          "es:DescribeOutboundCrossClusterSearchConnections",
          "es:DeleteOutboundCrossClusterSearchConnection",
          "es:DescribeReservedElasticsearchInstanceOfferings",
          "es:CreateServiceRole",
          "es:CreateElasticsearchServiceRole",
          "es:UpdatePackage",
          "es:RejectInboundCrossClusterSearchConnection",
          "es:DeleteInboundConnection",
          "es:GetPackageVersionHistory",
          "es:RejectInboundConnection",
          "es:PurchaseReservedElasticsearchInstanceOffering",
          "es:CreateVpcEndpoint",
          "es:DescribeInboundCrossClusterSearchConnections",
          "es:ListVersions",
          "es:DescribeReservedElasticsearchInstances",
          "es:ListDomainNames",
          "es:PurchaseReservedInstanceOffering",
          "es:CreatePackage",
          "es:DeleteVpcEndpoint",
          "es:DescribePackages",
          "es:ListElasticsearchInstanceTypes",
          "es:ListElasticsearchVersions",
          "es:DescribeElasticsearchInstanceTypeLimits",
          "es:CreateApplication",
          "es:RevokeVpcEndpointAccess"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = "dynamodb:ListStreams"
        Effect = "Allow"
        Resource = [
          "${aws_dynamodb_table.users_table.arn}/stream/*",
          "${aws_dynamodb_table.products_table.arn}/stream/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_ddb_to_opensearch_policy" {
  role       = aws_iam_role.opensearch_access_role.name
  policy_arn = aws_iam_policy.ddb_to_opensearch_policy.arn
}
