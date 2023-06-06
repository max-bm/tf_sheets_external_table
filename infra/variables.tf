variable "project_id" {
  default     = "blog-test-2-389008"
  type        = string
  description = "The project where the function should be deployed"
}

variable "region" {
  default     = "europe-west2"
  type        = string
  description = "Region"
}

variable "schema_file_path" {
  default     = "./config"
  type        = string
  description = "The location of the Bigquery YAML"
}
