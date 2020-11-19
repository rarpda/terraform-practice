data "aws_vpc" "default" {
  default = true
}

//resource "aws_instance" "testEC2" {
//  ami           = "ami-03657b56516ab7912"
//  instance_type = "t2.micro"
//}

resource "aws_iam_user" "test" {
//  name  = "${var.environments[count.index]}"
  name  = var.environments[count.index]
  count = 2
}

output "user_id" {
  value = aws_iam_user.test[*].name
}

module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "~> 3.0"

  account_alias = "awesome-company"

  minimum_password_length = 37
  require_numbers         = false
}


output "test" {
  value = element(var.environments,1)
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
