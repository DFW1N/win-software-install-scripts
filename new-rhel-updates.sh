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

echo "######################
##  ANSIBLE INSTALL ##
######################"

yum install gcc glibc glibc-common gd gd-devel
pip3 install --upgrade pip
pip3 install ansible
ansible-galaxy collection install azure.azcollection
sudo curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip3 install -r requirements-azure.txt
pip3 install azure-mgmt-nspkg==3.0.1

echo "################################
##  WINRM PIP KERBEROS INSTALL ##
#################################"

sudo yum -y install python3-devel krb5-devel krb5-libs krb5-workstation
pip3 install pywinrm[kerberos]

## Update RHEL
yum update -y
pip3 install ansible --user
subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms
dnf -y install ansible

echo "####################
##  BREW INSTALLS ##
####################"

## Install brew and all pre-req
yum groupinstall 'Development Tools' && sudo yum install curl file git -y
echo -ne '\n' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"' >>~/.bashrc
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bashrc
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bashrc
source  ~/.bashrc

## Use Brew to install the following packages:
brew install tfenv tfsec terrascan

## tfenv install version
tfenv install 1.0.0

## tfenv set version
tfenv use 1.0.0

## Exit the Shell script
exit
