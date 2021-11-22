#!/bin/bash

echo "###################################
## AUTHOR: SACHA ROUSSAKIS-NOTTER #
###################################"

echo "###################
##  INSTALL UNZIP ##
####################"

## Installs the Unzip package
yum install zip unzip -y

echo "########################
##  TERRAFORM INSTALL ##
########################"

## Install yum-utils
yum install -y yum-utils

## Install the packages
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

## Install Terraform
yum install terraform -y

echo "########################
##  AZURE CLI INSTALL ##
########################"

## RPM package import from Microsoft
rpm --import https://packages.microsoft.com/keys/microsoft.asc

## Create local azure-cli repository information.
sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

## Install with the yum install command.
yum install azure-cli

## Add azure-devops extension to the azure cli
az extension add --name azure-devops

## Show output of az version
az --version

echo "######################
##  ANSIBLE INSTALL ##
######################"

## Download latest epel-rpm-release
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

## Apply rpm package
rpm -i epel-release-latest-7.noarch.rpm

## Update RHEL
yum update -y

## Install Ansible
yum install ansible -y

## Check ansible is installed and in version
ansible --version

echo "####################
##  BREW INSTALLS ##
####################"

## Use Brew to install the following packages:
brew install tfenv tfsec terrascan

## tfenv install version
tfenv install 1.0.0

## tfenv set version
tfenv use 1.0.0

