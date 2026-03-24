resource "aws_glue_workflow" "stations_metadata_workflow" {
    name = "station-metadata-workflow"
}

resource "aws_glue_job" "curate_stationstimeseries" {
    name = "curate_timeseries"
    role_arn = aws_iam_role.glue.glue_role.arn

    glue_version = "4.0"
    number_of_workers = 2
    worker_type = "G.1X"

    command {
      name = "glueetl"
      script_location = "s3://${var.scripts_bucket}/glue/curate_timeseries.py"
      python_version = "3"
    }

    default_arguments = {
      "--raw_bucket" = var.raw_bucket
      "--curated_bucket" = var.curated_bucket
      "--job-language" = "python"
      "--enable-metrics" = "true"
    }
}

resource "aws_glue_trigger" "start_curate_stations" {
    name = "start_curate_stations"
    type = "WORKFLOW"
    workflow_name = aws_glue_job.curate_stations_metadata_workflow.name

    actions {
      job_name = aws_glue_job.curate_stations.name
    }
}

resource "aws_glue_trigger" "start_curate_timeseries" {
    name = "start_curate_timeseries"
    type = "CONDITIONAL"
    workflow_name = aws_glue_job.curate_stations_metadata_workflow.name

    predicate {
      conditions {
        job_name = aws_glue_job.curate_stations.name
        state = "SUCCEEDED"
      }
    }

    actions {
      job_name = aws_glue_job.curate_timeseries.name
    }
}