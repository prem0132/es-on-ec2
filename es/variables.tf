variable "location" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the Subnet. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "map_public_ip_on_launch" {
  description = "Should attach public ip to instances"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Should attach dns hostname to instances"
  type        = bool
  default     = true
}

variable "associate_public_ip_address_instance" {
  description = "Should attach public ip to instances"
  type        = bool
  default     = true
}

variable "es_tags" {
  description = "Additional tags for the instances"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "Key to be used"
  type        = string
}

variable "monitoring" {
  description = "monitoring enable"
  type        = bool
  default     = false
}

variable "es_az" {
  description = "es_az"
  type        = string
    default     = "us-east-2b"
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t2.medium"
}

variable "ip_whitelist" {
  description = "IPs to whitelist"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "elastic_password" {
  description = "Bootstrap Password for elastic user"
  type        = string
}

variable "node_count" {
  description = "number of nodes"
  type        = number
  default     = 3
}

variable "es_data_disk_size" {
  description = "ebs disk size of nodes"
  type        = number
  default     = 10
}

variable "cert_file_path" {
  description = "Path to the certficate"
  type        = string
  default     = "creds/ca.p12"
}

variable "cert_file_passwd" {
  description = "Password for the certficate"
  type        = string
  default     = ""
}