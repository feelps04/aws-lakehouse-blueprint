data "aws_iam_policy_document" "uploader" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]

    resources = [
      "arn:aws:s3:::${var.bronze_bucket}",
      "arn:aws:s3:::${var.bronze_bucket}/*"
    ]
  }
}

resource "aws_iam_user" "ingestion_uploader" {
  name = "${var.name_prefix}-ingestion-uploader"
}

resource "aws_iam_user_policy" "ingestion_uploader" {
  name   = "${var.name_prefix}-ingestion-uploader-policy"
  user   = aws_iam_user.ingestion_uploader.name
  policy = data.aws_iam_policy_document.uploader.json
}

resource "aws_iam_access_key" "ingestion_uploader" {
  user = aws_iam_user.ingestion_uploader.name
}

# Glue role skeleton (least privilege baseline)
data "aws_iam_policy_document" "glue_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_job_role" {
  name               = "${var.name_prefix}-glue-job-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume.json
}

data "aws_iam_policy_document" "glue_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.bronze_bucket}",
      "arn:aws:s3:::${var.bronze_bucket}/*",
      "arn:aws:s3:::${var.silver_bucket}",
      "arn:aws:s3:::${var.silver_bucket}/*",
      "arn:aws:s3:::${var.gold_bucket}",
      "arn:aws:s3:::${var.gold_bucket}/*"
    ]
  }

  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "glue_s3" {
  name   = "${var.name_prefix}-glue-s3-policy"
  role   = aws_iam_role.glue_job_role.id
  policy = data.aws_iam_policy_document.glue_s3.json
}

# Managed policy for Glue basic execution (optional but common)
resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
