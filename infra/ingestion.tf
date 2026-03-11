resource "aws_lambda_function" "ingest_stations_metadata" {
    filename = "fetch_stations_metadata.zip"
    function_name = "fetch_stations_metadata"
    role = aws_iam_role.fetch_stations_metadata.arn
    runtime = "python3.12"
    handler = "lambda_function.lambda_handler"

    timeout = 30
    memory_size = 256

    environment {
      variables = {
        RAW_BUCKET = var.raw_bucket
        WORKFLOW_NAME = var.stations_workflow_name
        ENVIRONMENT = var.environment
      }
    }

    publish = true
}