# EMR/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1" 
}

# --- Missing Variables from Error ---
variable "subnet_id" {
  description = "The ID of the Subnet where the EMR cluster will be launched (e.g., a private subnet)"
  type        = string
}

variable "emr_logs_bucket" {
  description = "The name of the S3 bucket for EMR logs (must be globally unique)"
  type        = string
}
# -----------------------------------

variable "cluster_name" {
  description = "The name for the EMR cluster"
  type        = string
  default     = "emr-ssm-cluster"
}

