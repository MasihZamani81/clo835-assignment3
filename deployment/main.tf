provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

resource "aws_ecr_repository" "my_repo" {
  name                 = "clo835-project"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Example comment to mark a section
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  id = "subnet-057a32bec48c268eb"  # Replace with your Subnet ID
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]  # Amazon's owner ID for Amazon Linux AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Filter for Amazon Linux 2 AMIs
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default.id
  key_name      = aws_key_pair.instance_key.key_name
  security_groups = [aws_security_group.allow_ssh.id]

  root_block_device {
    volume_size = 8  # Set the volume size to 40 GiB
  }

  tags = {
    Name = "MyInstance"
  }
}

resource "aws_key_pair" "instance_key" {
  key_name   = "instance_key"
  public_key = file(var.path_to_linux_key)
}