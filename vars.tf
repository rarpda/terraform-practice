variable "ec2Name" {
  type    = string
  default = "Ricardo"
}

variable "ec2Number" {
  type    = number
  default = 2
}

variable "environments" {
  type    = list(string)
  default = ["prod", "test", "uat"]
}

variable "ec2Map" {
  type = map
  default = {
    test = 2,
    red  = 3
  }
}