terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }

  required_version = "1.6.5"
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_athena_workgroup" "athena_spark_wg" {
  name        = var.athena_spark_wg_name
  description = "Athena analytics workgroup with PySpark Engine v3"

  force_destroy = true # Note: This flag is required to delete non-empty workgroups.

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    execution_role = aws_iam_role.athena_spark_wg_role.arn

    engine_version {
      selected_engine_version = var.engine_version
    }

    result_configuration {
      encryption_configuration {
        encryption_option = var.s3_encryption_option
      }

      output_location = "s3://${aws_s3_bucket.aws_athena_query_result_bucket.bucket}"
    }
  }

  tags = {
    namespace : var.namespace
  }
}

resource "aws_iam_role" "athena_spark_wg_role" {
  name = var.athena_spark_wg_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "athena.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = var.athena_spark_wg_role_inline_policy
    policy = data.aws_iam_policy_document.inline_policy.json
  }

  tags = {
    namespace : var.namespace
  }
}

resource "aws_s3_bucket" "aws_athena_query_result_bucket" {
  bucket = "${var.s3_bucket_prefix}-${data.aws_caller_identity.current.account_id}-${var.region}"

  force_destroy = true # Note: This flag is required to delete non-empty buckets

  tags = {
    namespace : var.namespace
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_prefix}-${data.aws_caller_identity.current.account_id}-${var.region}/*",
      "arn:aws:s3:::${var.s3_bucket_prefix}-${data.aws_caller_identity.current.account_id}-${var.region}"
    ]
  }

  statement {
    actions = [
      "athena:GetWorkGroup",
      "athena:TerminateSession",
      "athena:GetSession",
      "athena:GetSessionStatus",
      "athena:ListSessions",
      "athena:StartCalculationExecution",
      "athena:GetCalculationExecutionCode",
      "athena:StopCalculationExecution",
      "athena:ListCalculationExecutions",
      "athena:GetCalculationExecution",
      "athena:GetCalculationExecutionStatus",
      "athena:ListExecutors",
      "athena:ExportNotebook",
      "athena:UpdateNotebook"
    ]
    resources = ["arn:aws:athena:${var.region}:${data.aws_caller_identity.current.account_id}:workgroup/${var.athena_spark_wg_name}"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws-athena:*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws-athena*:log-stream:*"
    ]
  }

  statement {
    actions   = ["logs:DescribeLogGroups"]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*"]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["AmazonAthenaForApacheSpark"]
    }
  }

  # Permission to retrieve NOAA data from an external S3 bucket.
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::athena-examples-us-east-1/athenasparkblog/noaa-gsod-pds/parquet/*",
      "arn:aws:s3:::noaa-gsod-pds/2022/*",
      "arn:aws:s3:::noaa-gsod-pds",
      "arn:aws:s3:::athena-examples-us-east-1"
    ]
  }
}