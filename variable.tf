variable "profile" {
    type    = string
    default = "default"
  }
  
variable "region-master" {
    type    = string
    default = "us-east-1"
  }
  
variable "main_vpc_cidr" {
    default = "10.0.0.0/16"
  }
  
variable "public_subnet_cidr" {
    default = "10.0.3.0/24"
  }
  
variable "private_subnet_cidr" {
    default = "10.0.4.0/24"
  }
