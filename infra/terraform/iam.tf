module "iam" {
  source = "./modules/iam"

  name_prefix   = local.name
  bronze_bucket = module.lakehouse_buckets.bronze_bucket_name
  silver_bucket = module.lakehouse_buckets.silver_bucket_name
  gold_bucket   = module.lakehouse_buckets.gold_bucket_name
}

resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_exec_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_least_privilege" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]

    resources = compact([
      try(aws_dynamodb_table.alerts.arn, null),
      try(aws_dynamodb_table.users.arn, null)
    ])
  }

  statement {
    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${module.lakehouse_buckets.bronze_bucket_name}/${trim(var.bronze_ingestion_prefix, \"/\")}/*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  role   = aws_iam_role.lambda_exec_role.id
  policy = data.aws_iam_policy_document.lambda_least_privilege.json
}

# Exemplo de Role preparada para Cross-Account
# Esta role permite que uma identidade externa (ex: conta de Analytics)
# assuma permissões para ler a camada Gold.
resource "aws_iam_role" "cross_account_analytics_role" {
  count = var.analytics_account_id != "" ? 1 : 0

  name = "CrossAccountGoldDataAccess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.analytics_account_id}:root" # Variável para ID da conta externa
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "cross_account_gold_read" {
  count = var.analytics_account_id != "" ? 1 : 0

  statement {
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${module.lakehouse_buckets.gold_bucket_name}"
    ]
  }

  statement {
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${module.lakehouse_buckets.gold_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "cross_account_gold_read" {
  count = var.analytics_account_id != "" ? 1 : 0

  role   = aws_iam_role.cross_account_analytics_role[0].id
  policy = data.aws_iam_policy_document.cross_account_gold_read[0].json
}
