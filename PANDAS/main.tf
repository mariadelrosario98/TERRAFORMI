terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Buscar la AMI más reciente de Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Security Group (solo salida, sin SSH)
resource "aws_security_group" "outbound_only" {
  name        = "allow_outbound"
  description = "Allow all outbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = true
  }
}

# IAM Role para SSM
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Adjuntar política de SSM al rol
resource "aws_iam_role_policy_attachment" "ssm_role_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile para la EC2
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

# Instancia EC2 gestionada con SSM (sin SSH)
resource "aws_instance" "this" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  vpc_security_group_ids = [aws_security_group.outbound_only.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

#user_data = filebase(ruta al user_data) 

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip
              pip3 install pandas
              EOF

  tags = {
    Name = "EC2-SSM-Python-Pandas"
  }
}

# Outputs
output "instance_id" {
  value = aws_instance.this.id
}

output "instance_public_ip" {
  value = aws_instance.this.public_ip
}

output "instance_public_dns" {
  value = aws_instance.this.public_dns
}
