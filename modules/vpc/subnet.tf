# Public Subnet
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-subnet-public1-${var.region}a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-subnet-public2-${var.region}c"
  }
}

# Private Subnet
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-subnet-private1-${var.region}a"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-subnet-private2-${var.region}c"
  }
}