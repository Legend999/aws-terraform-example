terraform {
  source = "../../modules/iam"
}

dependency "dynamodb" {
  config_path = "../dynamodb"
}

inputs = {
  role_name           = "ec2-dynamodb-role"
  dynamodb_table_arn  = dependency.dynamodb.outputs.urls_arn
}
