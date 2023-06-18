variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "demo_application_name" {
  type    = string
  default = "ec2-connectivity-demo"
}

variable "ec2_key_pair_name" {
  type    = string
  default = "ec2-connectivity-demo"
}
