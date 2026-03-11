resource "aws_s3_bucket" "raw" {
    bucket = var.raw_bucket
}

resource "aws_s3_bucket" "curated" {
    bucket = var.curated_bucket
}