resource "aws_instance" "this" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami                         = data.aws_ami.this.id
  instance_type               = var.instance_type
  key_name                    = "aws_key_pair.this.key_name"
  security_groups             = [aws_security_group.this.name]
  user_data                   = var.user_data
  user_data_replace_on_change = true
}


data "aws_ami" "this" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  ## homework:start
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  ## homework:end
}

resource "aws_key_pair" "this" {
  key_name   = "my-ec2-key"
  public_key = file("C:/Users/ASUS/Downloads/eb-terraform-quickstart_homework/eb-terraform-quickstart_homework/task_3/.shh/key.pub")
}

resource "aws_security_group" "this" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0" # use more restrictions in a production setting
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

