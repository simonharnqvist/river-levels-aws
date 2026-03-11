variable "environment" {
  type    = string
  default = "dev"
}

variable "raw_bucket" {
  type = string
}

variable "curated_bucket" {
  type = string
}

variable "scripts_bucket" {
  type = string
}

variable "station_ids" {
  type = list(string)
}

variable "stations_workflow_name" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}