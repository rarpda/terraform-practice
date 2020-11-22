terraform {
  backend "s3" {
    bucket = "ricardo-terraform-bucket"
    key    = "practice-course"
    region = "eu-west-2"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_s3_bucket" "ricardo-vpc-flow-logs" {
  bucket = "ricardo-vpc-flow-logs"
}

locals {
  common_tags = {
    env = "prod"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("mykey.pub")
}

resource "aws_instance" "testEC2" {
  ami               = "ami-0271d331ac7dab654"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-2a"
  security_groups   = [aws_security_group.no_traffic.name]
  key_name      = aws_key_pair.mykey.key_name
  tags              = local.common_tags

  root_block_device {
    encrypted = true
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("mykey")
  }

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }

  provisioner "remote-exec" {
    inline = [
      "ls"
    ]
  }
}

resource "aws_security_group" "no_traffic" {
  name        = "https"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id
  
  
  ingress {
    description = "ssh from anywhere"
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }
  tags = {
    owner = "ricardo"
  }
}

resource "aws_iam_user" "test" {
  //  name  = "${var.environments[count.index]}"
  name  = var.environments[count.index]
  count = 2
}

//resource "aws_s3_bucket" "recardo" {
//}

output "test23" {
  value = data.aws_vpc.default.cidr_block
}


output "bucket_id" {
  value = data.aws_s3_bucket.ricardo-vpc-flow-logs.id
}

output "user_id" {
  value = aws_iam_user.test[*].name
}

//module "iam_account" {
//  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
//  version = "~> 3.0"
//
//  account_alias = "awesome-company"
//
//  minimum_password_length = 37
//  require_numbers         = false
//}


output "test" {
  value = element(var.environments, 1)
}

//output "test2" {
// value = lookup(var.ec2Map,test)
//}

//data "aws_ami" "example" {
//  most_recent = true
//
//  owners = ["self"]
//  tags = {
//    Name   = "app-server"
//    Tested = "true"
//  }
//}
//
