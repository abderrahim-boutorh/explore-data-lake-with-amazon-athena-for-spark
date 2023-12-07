variable "region" {
  type        = string
  description = "The AWS region to deploy to"
  default     = "us-east-1" # Make sure to use a region where Spark engine is available.
}

variable "athena_spark_wg_name" {
  type        = string
  description = "Analytics Workgroup name"
  default     = "DemoAthenaSparkWorkgroup"
}

variable "s3_bucket_prefix" {
  type        = string
  description = "S3 bucket prefix"
  default     = "athena-spark-demo"
}

variable "s3_encryption_option" {
  type        = string
  description = "S3 encryption option"
  default     = "SSE_S3"
}

variable "namespace" {
  type        = string
  description = "Namespace"
  default     = "AmazonAthenaForApacheSpark"
}

variable "engine_version" {
  type        = string
  description = "Engine version"
  default     = "PySpark engine version 3"
}

variable "athena_spark_wg_role_name" {
  type        = string
  description = "Athena Spark Workgroup role name"
  default     = "athena_spark_wg_role"
}

variable "athena_spark_wg_role_inline_policy" {
  type        = string
  description = "Athena Spark Workgroup role inline policy"
  default     = "athena_spark_wg_role_inline_policy"
}