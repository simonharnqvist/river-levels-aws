resource "aws_lambda_function" "ingest_stations_metadata" {
    filename = "fetch_stations_metadata.zip"
    function_name = "fetch_stations_metadata"
    role = aws_iam_role.fetch_stations_metadata.arn
    runtime = "python312"
}