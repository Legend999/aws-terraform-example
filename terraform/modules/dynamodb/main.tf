resource "aws_dynamodb_table" "urls" {
  name         = "urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "short_id"

  attribute {
    name = "short_id"
    type = "S"
  }
}
