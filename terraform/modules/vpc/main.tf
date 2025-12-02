# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}-vpc"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# ---------------------------
# Public Subnets
# ---------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                = "${var.name}-public-${count.index}"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# ---------------------------
# Private Subnets
# ---------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name                                = "${var.name}-private-${count.index}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# ---------------------------
# NAT Gateway EIPs (FIXED → removed deprecated vpc=true)
# ---------------------------
resource "aws_eip" "nat" {
  count = length(var.public_subnets)

  tags = {
    Name = "${var.name}-nat-eip-${count.index}"
  }
}

# ---------------------------
# NAT Gateway
# ---------------------------
resource "aws_nat_gateway" "natgw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.name}-nat-${count.index}"
  }
}

# ---------------------------
# Public Route Table + Routes
# ---------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------
# Private Route Tables + Routes (One per AZ)
# ---------------------------
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-private-rt-${count.index}"
  }
}

resource "aws_route" "private_route" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
