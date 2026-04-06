# ─────────────────────────────────────────
# VPC PRINCIPAL
# ─────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "VPC-Innovatech" }
}

# ─────────────────────────────────────────
# SUBREDES
# ─────────────────────────────────────────
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "Subred-Publica-Front" }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = { Name = "Subred-Privada-Back-Data" }
}

# ─────────────────────────────────────────
# INTERNET GATEWAY (entrada pública para el front)
# ─────────────────────────────────────────
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "IGW-Innovatech" }
}

# ─────────────────────────────────────────
# NAT GATEWAY (salida para subred privada (back y bdd))
# ─────────────────────────────────────────
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "EIP-NAT-Innovatech" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id   # El NAT vive en la subred PÚBLICA
  tags          = { Name = "NAT-Innovatech" }

  depends_on = [aws_internet_gateway.igw]
}

# ─────────────────────────────────────────
# ROUTE TABLE PÚBLICA → Internet Gateway
# ─────────────────────────────────────────
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "RT-Publica" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ─────────────────────────────────────────
# ROUTE TABLE PRIVADA → NAT Gateway
# ─────────────────────────────────────────
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "RT-Privada" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
# hubo una vez una camioneta llena de choclos
# doblo y chocló xddd
