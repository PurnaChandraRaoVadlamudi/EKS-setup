resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }

}
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true #aws automatically assign public ip address to the instance launched in this subnet

  tags = {
    Name = "${var.vpc_name}-public-subnet${count.index + 1}"

    "kubernetes.io/role/elb "          = "1"      #public loadbalancer want to expose your service to the internet
    "kubernetes.io/cluster/my-cluster" = "shared" # provision multiple Eks
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.private_availability_zones[count.index]

  tags = {
    Name = "${var.vpc_name}-private-subnet${count.index + 1}"

    "kubernetes.io/role/internal-elb"  = "1"      #priavate loadbalancer want to expose your service internally within the vpc
    "kubernetes.io/cluster/my-cluster" = "shared" # provision multiple Eks cluster in single aws account this is the eks cluster name and the value can be shared or owned
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
 
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }
   depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"

  }

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.vpc_name}-private-rt"

  }

}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_availability_zones)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id

}


