variable "region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "prefix" {
  type        = string
  description = "A prefix to use when naming resources."
}

variable "mwaa_max_workers" {
  type        = number
  description = "Maximum number of MWAA workers."
  default     = 2
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default = "10.192.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnets' CIDR blocks."
  default = [
    "10.192.10.0/24",
    "10.192.11.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets' CIDR blocks."
  default = [
        "10.192.20.0/24",
        "10.192.21.0/24"
  ]
}

variable "cluster_id" {
  type = string
  description = "cluster id associated to cluster arn"
}
 
variable "airflow_dags_bucket" {
  type = string
  description = "s3 bucket name for airflow dags"
}

variable "namespace_name" {
  type = string 
  description = "name of mwaa namespace"
}

variable "vpc_id" {
  type = "string"
  description = "vpc id for mwaa"
}

variable "vpc_pv_sub_1" {
  type = "string"
  description = "vpc first private subnet for mwaa"
}

variable "vpc_pv_sub_2" {
  type = "string"
  description = "vpc second private subnet for mwaa"
}

variable "vpc_pv_sub_3" {
  type = "string"
  description = "vpc third private subnet for mwaa"
}

variable "mwaa_role" {
  type = "string"
  description = "role name for mwaa"
}

variable "service_account_name" {
  type = "string"
  description = "role name for mwaa"
}
