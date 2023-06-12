# --- networking/main.tf --

# the random integer will always assign a new number to the VPC
resource "random_integer" "random" {
    min = 1
    max = 100
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
}

resource "aws_internet_gateway" "igw_ue1_devqa" {
  vpc_id = "${aws_vpc.vpc_ue1_devqa.id}"

  tags = {
    Name = "igw_ue1_devqa-${random_integer.random.id}"
    Project = "Migration"
    Environment = "Development"
  }
}