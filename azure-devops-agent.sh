####################
## PRE-REQUISITES ##
####################

# 1. Meet the following os requirements:
#    1.1 Ubuntu 16 LTS or newer
#    1.2 Red Hat 7.1 or newer

# 2. Azure DevOps Pat Token for Authentication 
#    2.1 Pat Authorization Scope: Agent Pools (read, manage), If Deployment group (read, manage)
# 3. Azure DevOps Organization Name
# 4. Azure DevOps Agent Pool Name

echo "###############
## VARIABLES ##
###############"

AgentName="ansible-agent"
AgentPoolName="ansible-agent"
DevOpsUrl=""
DevOpsPatToken=""
AdminUser="adminuser"
PackerUser="packer"
SaSasToken="https://vstsagentpackage.azureedge.net/agent/2.195.0/vsts-agent-linux-x64-2.195.0.tar.gz"

# Make directory for DevOps Agent Install
mkdir myagent && cd myagent

## Fetch DevOps Agent Binary from Storage Account
wget "$SaSasToken" -k -O vsts-agent.tar.gz

cd myagent

## Extracting files from Archive
tar zxvf vsts-agent.tar.gz && rm vsts-agent.tar.gz

## Azure DevOps Unattended Agent Setup
./config.sh --unattended --agent "$AgentName" --url "$DevOpsUrl" --auth PAT --token "$DevOpsPatToken" --pool "$AgentPoolName" --replace --acceptTeeEula & wait $!

## Creates a Service file that points to ./runsvc.sh
sudo sh svc.sh install $AdminUser

## Start the Service
sudo sh svc.sh start
