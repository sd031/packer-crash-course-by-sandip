# Variables
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_account_file" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Sources (Builders)

# Amazon EBS builder
source "amazon-ebs" "demo" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"
  source_ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  ssh_username = "ubuntu"
  ami_name = "packer-nodejs-demo-ami-${local.timestamp}"
}

# Google Compute Engine builder
source "googlecompute" "demo" {
  project_id = var.gcp_project_id
  account_file = var.gcp_account_file
  source_image_family = "ubuntu-2004-lts"
  zone = "us-west1-a"
  instance_name = "packer-nodejs-demo"
  ssh_username = "ubuntu"
  image_name = "packer-nodejs-demo-image-${local.timestamp}"
}

# Builds
build {
  sources = [
    "source.amazon-ebs.demo",
    "source.googlecompute.demo",
  ]

  # Provisioners
  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
    ]
  }

  provisioner "file" {
    source      = "app/"
    destination = "/tmp/app"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/app /var/www/app",
      "cd /var/www/app",
      "npm install",
      "sudo systemctl enable --now app.service",
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}