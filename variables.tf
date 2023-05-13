# Provider
variable "region" {
  type    = string
  default = "us-east-2"
}

variable "avail_zone" {
  type = map(string)
  default = {
    0 = "us-east-2a"
    1 = "us-east-2b"
    2 = "us-east-2c"
  }
}

# VPC Variables
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_network_address_usage_metrics" {
  type    = bool
  default = false
}

variable "sub_cidr_block" {
  type = map(list(string))
  default = {
    "public"   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    "private"  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
    "database" = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
  }
}

# S3 Variables
variable "bucket" {
  type    = string
  default = "backend-wqqeqweqe"
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "object_lock_enabled" {
  type    = bool
  default = false
}

# ELB Variables
variable "alb_ingress_ports" {
  type    = list(string)
  default = ["80", "443", "9090", "9100"]
}

variable "alb_port" {
  type    = number
  default = 80
}

variable "application_server_port" {
  type    = number
  default = 80
}

variable "monitoring_server_port" {
  type    = number
  default = 9090
}

# Lunch Config Variables
variable "lc_ingress_ports" {
  type    = list(string)
  default = ["80", "22", "2049", "9100", "9090"]
}

# Baiston Host Variables
variable "baiston_ingress_ports" {
  type    = list(string)
  default = ["22", "80", "443", "3306"]
}

# RDS Host Variables
variable "rds_ingress_ports" {
  type    = list(string)
  default = ["3306"]
}

# Efs Host Variables
variable "efs_ingress_ports" {
  type    = list(string)
  default = ["2049"]
}


# Monitoring instance Variables
variable "monitoring_ingress_ports" {
  type    = list(string)
  default = ["9090", "22", "9100"]
}
