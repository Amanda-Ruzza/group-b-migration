# --- root/variables.tf --

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
    type = string 
    default = "10.0.0.0/16"
}

variable "public_cidrs" {
    type = list 
    default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24", "10.0.8.0/24"]
}

variable "private_cidrs" {
    type = list 
    default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  
}

variable "public_sn_count" {
    type = number 
    default = 4
}

variable "private_sn_count" {
    type = number 
    default = 3
  
}

variable "max_subnets" {
    type = number
    default = 20
}