locals {
  prefix = "/${var.environment}/sepa"
}

resource "aws_ssm_parameter" "base_url" {
  name  = "${local.prefix}/base_url"
  type  = "String"
  value = "https://api.sepa.org.uk/kiwis"
}

resource "aws_ssm_parameter" "poll_interval" {
  name  = "${local.prefix}/poll_interval_minutes"
  type  = "String"
  value = "15"
}

resource "aws_ssm_parameter" "raw_bucket" {
  name  = "${local.prefix}/raw_bucket"
  type  = "String"
  value = var.raw_bucket
}

resource "aws_ssm_parameter" "curated_bucket" {
  name  = "${local.prefix}/curated_bucket"
  type  = "String"
  value = var.curated_bucket
}

resource "aws_ssm_parameter" "station_ids" {
  name  = "${local.prefix}/station_ids"
  type  = "String"
  value = jsonencode(var.station_ids)
}