resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = var.vpc_tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id                          = aws_vpc.vpc.id
  availability_zone               = var.es_az
  cidr_block                      = var.public_subnet_cidr
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  tags = var.vpc_tags
}

resource "aws_internet_gateway" "igw_es" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_es.id
    }
    tags = var.vpc_tags
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}