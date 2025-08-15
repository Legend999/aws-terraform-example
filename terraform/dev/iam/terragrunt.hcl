terraform {
  source = "../../modules/iam"
}

dependency "dynamodb" {
  config_path = "../dynamodb"
}

inputs = {
  role_name          = "ec2-dynamodb-role"
  dynamodb_table_arn = dependency.dynamodb.outputs.urls_arn
  rds_secret_arn     = "arn:aws:secretsmanager:eu-north-1:969702371059:secret:rds!db-c1147c30-c4ac-4cb3-a651-5f56f156f997-I9I36W"
}
