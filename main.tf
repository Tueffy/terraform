#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-958128fa
#
# Your subnet ID is:
#
#     subnet-6987b713
#
# Your security group ID is:
#
#     sg-73a74919
#
# Your Identity is:
#
#     terraform-training-toucan
#

terraform {
  backend "atlas" {
    name = "tueffy/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-central-1"
}

variable "num_webs" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.num_webs}"
  ami                    = "ami-958128fa"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-6987b713"
  vpc_security_group_ids = ["sg-73a74919"]

  tags {
    Identity = "terraform-training-toucan"
    Creator  = "Christian"
    Product  = "Training"
    Count    = "web ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
