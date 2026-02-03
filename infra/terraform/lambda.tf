resource "aws_lambda_function" "alerts_processor" {
  count = var.enable_lambda ? 1 : 0

  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout_seconds
  memory_size   = var.lambda_memory_mb

  s3_bucket = var.lambda_code_s3_bucket
  s3_key    = var.lambda_code_s3_key

  lifecycle {
    precondition {
      condition     = var.lambda_code_s3_bucket != "" && var.lambda_code_s3_key != ""
      error_message = "To enable Lambda, set lambda_code_s3_bucket and lambda_code_s3_key to a deployment package (.zip) in S3."
    }
  }

  environment {
    variables = {
      ALERTS_TABLE_NAME = aws_dynamodb_table.alerts.name
      USERS_TABLE_NAME  = aws_dynamodb_table.users.name
      BRONZE_BUCKET     = module.lakehouse_buckets.bronze_bucket_name
      BRONZE_PREFIX     = trim(var.bronze_ingestion_prefix, "/")
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  count = var.enable_lambda && var.enable_bronze_s3_trigger ? 1 : 0

  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alerts_processor[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${module.lakehouse_buckets.bronze_bucket_name}"
}

resource "aws_s3_bucket_notification" "bronze_notifications" {
  count  = var.enable_lambda && var.enable_bronze_s3_trigger ? 1 : 0
  bucket = module.lakehouse_buckets.bronze_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.alerts_processor[0].arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = trim(var.bronze_ingestion_prefix, "/")
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
