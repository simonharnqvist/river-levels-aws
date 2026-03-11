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

variable "station_ids" {
  type = list(string)
}