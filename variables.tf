variable "region" {}
variable "vpc_name" {}
variable "vpc_cidr" {}

variable "public_availability_zones" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_availability_zones" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}


variable "cluster_name" {}
variable "cluster_version" {}


variable "node_group_desired_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}

variable "node_group_min_size" {
  type = number

}

variable "node_group_instance_types" {
  type = list(string)
}
