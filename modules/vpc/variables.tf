variable "region" {}

variable "vpc_cidr" {}

variable "vpc_name" {
  description = "vpc name "
  type        = string
}

variable "public_availability_zones" {
  description = "list of availability zones"
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "public subnet cidr block"
  type        = list(string)

}

variable "private_availability_zones" {
  description = "list of availability zones"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "private subnet cidr block"
  type        = list(string)
}

