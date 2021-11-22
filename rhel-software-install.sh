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

## Exit the Shell script
exit
