terraform {
  source = "../../modules/lambda"
}

inputs = {
  name = "hello-lambda"
}

# aws lambda invoke \
# --function-name hello-lambda \
# --payload '{}' \
# response.json