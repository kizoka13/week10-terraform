provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id     = aws_vpc.example.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)

  availability_zone = element(
    flatten([for az in data.aws_availability_zones.available.names : repeat(2, az)]),
    count.index
  )
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id     = aws_vpc.example.id
  cidr_block = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)

  availability_zone = element(
    flatten([for az in data.aws_availability_zones.available.names : repeat(2, az)]),
    count.index
  )
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "example" {
  name_prefix = "example-"
}

resource "aws_network_acl" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_network_acl_rule" "example" {
  count = 4
  rule_number   = count.index
  rule_action   = "allow"
  protocol      = "tcp"
  egress        = false
  cidr_block    = "0.0.0.0/0"
  from_port     = 0
  to_port       = 65535
  network_acl_id = aws_network_acl.example.id
}


resource "aws_security_group_rule" "example" {
  count = 4
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

resource "aws_subnet_network_acl_association" "example" {
  count      = 2
  subnet_id  = aws_subnet.private[count.index].id
  network_acl_id = aws_network_acl.example.id
}
