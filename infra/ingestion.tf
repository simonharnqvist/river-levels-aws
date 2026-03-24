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

# EventBridge to trigger ingestion
resource "aws_cloudwatch_event_rule" "every_month" {
    name = "every-month"
    schedule_expression = "rate(1 months)"
}

resource "aws_cloudwatch_event_target" "ingest_stations_every_month" {
    rule = aws_cloudwatch_event_rule.every_month.name
    target_id = "ingest_stations_metadata"
    arn = aws_lambda_function.ingest_stations_metadata.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ingest_station_metadata" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.ingest_stations_metadata.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_month.arn
}