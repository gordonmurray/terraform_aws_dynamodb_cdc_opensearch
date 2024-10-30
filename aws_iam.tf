resource "aws_iam_role" "opensearch_access_role" {
  name = "OpenSearchDDBAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "opensearchservice.amazonaws.com"
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
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.users_table.stream_arn,
          aws_dynamodb_table.products_table.stream_arn
        ]
      },
      {
        Action = [
          "es:ESHttpPost"
        ]
        Effect   = "Allow"
        Resource = aws_opensearch_domain.example_domain.arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_ddb_to_opensearch_policy" {
  role       = aws_iam_role.opensearch_access_role.name
  policy_arn = aws_iam_policy.ddb_to_opensearch_policy.arn
}
