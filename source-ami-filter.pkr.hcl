# Variables
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Sources (Builders)
source "amazon-ebs" "demo" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }

  instance_type = "t2.micro"
  ssh_username = "ubuntu"
  ami_name = "packer-demo-ami-${local.timestamp}"
}

# Builds
build {
  sources = [
    "source.amazon-ebs.demo",
  ]

  # Provisioners and Post-processors go here
}
