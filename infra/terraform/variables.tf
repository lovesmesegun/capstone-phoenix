variable "region" {
  description = "AWS Region"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 Key Pair name"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR notation"
  type        = string
}