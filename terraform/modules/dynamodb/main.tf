resource "aws_dynamodb_table" "urls" {
  name           = "urls"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "short_id"

  attribute {
    name = "short_id"
    type = "S"
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-dynamodb-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["dynamodb:*"],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.urls.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-dynamodb-profile"
  role = aws_iam_role.ec2_role.name
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}
