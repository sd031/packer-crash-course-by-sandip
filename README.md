# packer-crash-course-by-sandip

#Installations:
https://developer.hashicorp.com/packer/downloads?product_intent=packer

# Commands
To init:
packer init <packer template file>
e.g. packer init main.pkr.hcl

To validate packer template:
packer validate <packer template file>
e.g. packer validate main.pkr.hcl

to start image build:
packer build <packer template file>
e.g. packer build main.pkr.hcl

to pass aws vartiaable as params:
packer -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY"