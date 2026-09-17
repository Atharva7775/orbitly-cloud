variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups (EKS nodes) allowed to reach Postgres on 5432."
  type        = list(string)
}

variable "instance_class" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "allocated_storage_gb" {
  type = number
}

variable "engine_version" {
  type    = string
  default = "16.4"
}

variable "database_name" {
  type    = string
  default = "orbitly"
}

variable "username" {
  type    = string
  default = "orbitly"
}
