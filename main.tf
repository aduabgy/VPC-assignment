
# Creating networkinf for the project in EU-west-2
resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block           = var.VPC-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "Prod-rock-VPC"
  }

}

# Public Subnet 1 
resource "aws_subnet" "Test-public-sub1" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = var.public-sub1-cidr
  availability_zone = var.AZ1

  tags = {
    Name = "Test-public-sub1"
  }

}

# Public Subnet 2 
resource "aws_subnet" "Test-public-sub2" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = var.public-sub2-cidr
  availability_zone = var.AZ1

  tags = {
    Name = "Test-public-sub1"
  }

}


# Private Subnet 1 
resource "aws_subnet" "Test-priv-sub1" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = var.private-sub1-cidr
  availability_zone = var.AZ1

  tags = {
    Name = "Test-priv-sub1"
  }

}

# Private Subnet 2 

resource "aws_subnet" "Test-priv-sub2" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = var.private-sub2-cidr
  availability_zone = var.AZ2

  tags = {
    Name = "Test-priv-sub2"
  }

}

# Public Route table 

resource "aws_route_table" "Test_pub_route_table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test_pub_route_table"
  }

}

# Private Route table 

resource "aws_route_table" "Test_priv_route_table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Test_Nat_gateway.id
  }

  tags = {
    Name = "Test_priv_route_table"
  }

}

# Associate public subnets with the public route table 

resource "aws_route_table_association" "pub_sub1_route_assoc" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test_pub_route_table.id
}

resource "aws_route_table_association" "pub_sub2_route_assoc" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test_pub_route_table.id
}



# Associate private subnets with the private route table 
resource "aws_route_table_association" "priv_sub1_route_assoc" {
  subnet_id      = aws_subnet.Test-priv-sub1.id
  route_table_id = aws_route_table.Test_priv_route_table.id
}

resource "aws_route_table_association" "priv_sub2_route_assoc" {
  subnet_id      = aws_subnet.Test-priv-sub2.id
  route_table_id = aws_route_table.Test_priv_route_table.id
}

# Internet Gateway 

resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }

}

# Associate the internet gateway to the public route table 

resource "aws_route" "Test-igw-association" {
  route_table_id         = aws_route_table.Test_pub_route_table.id
  gateway_id             = aws_internet_gateway.Test-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Allocate elastic ip address for the Nat gateway
resource "aws_eip" "eip_for_nat_gateway" {
  vpc = true
  tags = {
    Name = "eip-for-nat-gateway"
  }
}

# Creating Nat gateway
resource "aws_nat_gateway" "Test_Nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id     = aws_subnet.Test-public-sub1.id

  tags = {
    Name = "Test-Nat-gateway"
  }

}
 
