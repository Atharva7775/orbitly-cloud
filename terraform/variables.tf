variable "environment" {
  description = "Deployment environment name (prod, prod-eu, staging, qa)."
  type        = string
}

variable "region" {
  description = "AWS region for this environment."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the environment VPC."
  type        = string
}

variable "availability_zones" {
  description = "AZs to spread subnets across (at least two for RDS Multi-AZ)."
  type        = list(string)
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_allocated_storage_gb" {
  type    = number
  default = 50
}

variable "cluster_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.30"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}
