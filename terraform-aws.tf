provider "aws" {
  region = "eu-west-1"
}


resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "example_vpc"
  }
}

# Create subnets
resource "aws_subnet" "example_public_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "example_private_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.2.0/24"
}

# Create internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

#All traffic allowed to go to igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "example_public_subnet_rt_association" {
  subnet_id      = aws_subnet.example_public_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Create security group
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id
  name_prefix = "example_sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
/*resource "aws_instance" "example_ec2" {
  ami           = "ami-00aa9d3df94c6c354"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_private_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "example_ec2"
  }
}
*/
