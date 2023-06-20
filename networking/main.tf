# --- networking/main.tf --

# data source for fetching AZ

data "aws_availability_zones" "available" {
    state = "available"
}

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
        
    }
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "igw_ue1_devqa" {
  vpc_id = "${aws_vpc.vpc_ue1_devqa.id}"

  tags = {
    Name = "igw_ue1_devqa-${random_integer.random.id}"  
  }
}

resource "aws_route_table" "rtb_ue1_pub_devqa" {
  vpc_id = "${aws_vpc.vpc_ue1_devqa.id}"

    tags = {
    Name = "rtb_ue1_pub_-${random_integer.random.id}"  
  }

}

# Setting up a default Route for all IP addresses to be used by resources that don't have a specified RT
resource "aws_route" "default_route" {
    route_table_id = aws_route_table.rtb_ue1_pub_devqa.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_ue1_devqa.id
}

# Setting up the Default RT as a Private RT
resource "aws_default_route_table" "rtb_ue1_pri_devqa" {
    default_route_table_id = aws_vpc.vpc_ue1_devqa.default_route_table_id

    tags = {
    Name = "rtb_ue1_pri_-${random_integer.random.id}"  
  }
  
}
resource "aws_subnet" "sbn_ue1_pub_devqa" {
    count = var.public_sn_count
    vpc_id = aws_vpc.vpc_ue1_devqa.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = random_shuffle.az_list.result[count.index]
    tags = {
        Name = "sbn_ue1_pub_devqa-${count.index +1 }"
        
        }
    }

# Connecting the pub sn with the pub RT using a Route Table Association
resource "aws_route_table_association" "rtb_ue1_pub_assoc_devqa" {
    count = var.public_sn_count
    subnet_id = aws_subnet.sbn_ue1_pub_devqa.*.id[count.index]
    route_table_id = aws_route_table.rtb_ue1_pub_devqa.id
}

resource "aws_subnet" "sbn_ue1_pri_devqa" {
    count = var.private_sn_count
    vpc_id = aws_vpc.vpc_ue1_devqa.id
    cidr_block = var.private_cidrs[count.index]
    map_public_ip_on_launch = false
    availability_zone = random_shuffle.az_list.result[count.index]

    tags = {
        Name = "sbn_ue1_pri_devqa-${count.index +1 }"        
        }
    }

