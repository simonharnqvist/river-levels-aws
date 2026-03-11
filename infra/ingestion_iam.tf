resource "aws_iam_role" "lambda_stations_role" {
  name = "lambda_stations_metadata_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_stations_policy" {
  name = "lambda_stations_metadata_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # --- S3 write access ---
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${var.raw_bucket}/raw/*"
        ]
      },

      # --- Glue workflow trigger ---
      {
        Effect = "Allow"
        Action = [
          "glue:StartWorkflowRun"
        ]
        Resource = "arn:aws:glue:${var.region}:${var.account_id}:workflow/${var.stations_workflow_name}"
      },

      # --- CloudWatch Logs ---
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_stations_attach" {
  role       = aws_iam_role.lambda_stations_role.name
  policy_arn = aws_iam_policy.lambda_stations_policy.arn
}
