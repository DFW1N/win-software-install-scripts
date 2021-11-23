#!/bin/bash -e

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

## Exit the Shell script
exit
