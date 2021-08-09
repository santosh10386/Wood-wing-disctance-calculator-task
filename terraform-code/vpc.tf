
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}_gw"
  }
}

resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidr, count.index)
  availability_zone       = "${element(var.azs, count.index)}"
  //availability_zone_id       = "${element(var.azs_id, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-subnet-${count.index}"
  }
}

resource "aws_route_table" "rc" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}_rt"
  }
} 

resource "aws_route_table_association" "a" {
  count = length(var.subnet_cidr)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rc.id
}