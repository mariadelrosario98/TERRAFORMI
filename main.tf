terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


module "ec2" {
  source = "./ec2"

  ## homework:start
  instance_type = "t3.micro"
  ## homework:end

  ## homework:start
  public_ssh_key = file("C:/Users/ASUS/Downloads/eb-terraform-quickstart_homework/eb-terraform-quickstart_homework/task_3/.shh/key.pub")
  ## homework:end

  user_data = filebase64("./scripts/user_data.sh")
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}
