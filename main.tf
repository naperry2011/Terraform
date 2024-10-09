# Provider Block:
# Specifies the provider you are using and sets the region

provider "aws" {
  region = "us-east-1"
}


# VPC Resource: Defines a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My_vpc"
  }
}

# Subnets: Defines both public and private subnets within the VPC
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.my_vpc.id

  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public_subnet"
  }
}


# Security Groups: Defines the security group settings
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private_subnet"
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web_SG"
  }
}



# EC2 Instance: Creates an EC2 instance using Ubuntu and places it in the public subnet
resource "aws_instance" "web_server" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnets.id
  security_groups = [ aws_security_group.web_sg.id ]

  tags = {
    Name = "Web_Server"
  }
}

# Outputs: the public IP address of the created EC2 instance for easy
output "instance_public_ip" {
  value = "aws_instance.web_server.public_ip"
}
