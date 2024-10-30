resource "aws_dynamodb_table" "users_table" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email" # Attribute for GSI
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamo_db_kms.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }

  tags = {
    Name = "Users table"
  }
}

resource "aws_dynamodb_table" "products_table" {
  name         = "products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "product_id"
  range_key    = "expiration_date"

  attribute {
    name = "product_id"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "expiration_date"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamo_db_kms.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "expiration-date-index"
    projection_type = "ALL"
    range_key       = "expiration_date"
  }

  tags = {
    Name = "Products table"
  }
}
