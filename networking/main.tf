# --- networking/main.tf --

# data source for fetching AZ
data "aws_availability_zones" "available" {}

# the random integer will always assign a new number to the VPC
resource "random_integer" "random" {
    min = 1
    max = 100
}
resource "random_shuffle" "az_list" {
    input = data.aws_availability_zones.available.names 
    result_count = var.max_subnets
}

resource "aws_vpc" "vpc_ue1_devqa" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true 
    enable_dns_support = true 

    tags = {
        Name = "vpc_ue1_devqa-${random_integer.random.id}"
        Project = "Migration"
        Environment = "Development"
    }
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "sbn_ue1_pub_devqa" {
    count = var.public_sn_count
    vpc_id = aws_vpc.vpc_ue1_devqa.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]
    #availability_zone = random_shuffle.az_list.result_count[count.index]

    tags = {
        Name = "sbn_ue1_pub_devqa-${count.index +1 }"
        Project = "Migration"
        Environment = "Development"}
    
    }

resource "aws_subnet" "sbn_ue1_pri_devqa" {
    count = var.private_sn_count
    vpc_id = aws_vpc.vpc_ue1_devqa.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = false
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]
    #availability_zone = random_shuffle.az_list.result_count[count.index]

    tags = {
        Name = "sbn_ue1_pri_devqa-${count.index +1 }"
        Project = "Migration"
        Environment = "Development"}
    
    }


