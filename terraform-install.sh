## Install yum-utils
yum install -y yum-utils

## Install the packages
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

## Install Terraform
yum install terraform -y
