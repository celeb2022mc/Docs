# VM Provisioning

This repository contains all of the terraform modules used to deploy compliant Gas Power Linux and Windows VMs in Azure.

## Repository Structure

    + modules            # All terraform modules
    +- VM_*              # These are the base modules used as building blocks for our gas power configurations
    +- GP_*              # These are complete VM builds for linux and windows
    + scripts            # Scripts used to configure VMs (Qualys, Splunk, Crowdstrike, Disk Mount, etc.)
                         # These scripts are stored in the centralized storage account to be retrieved during VM creation

## Prequisites
1. Base Infra and Base Networking Deployed
2. LDAP password and Domain Join password stored in 328 and 362 key vaults
3. Radius passwords stored in respective region centralized key vaults

## VM Deployment

- The following modules can be referenced by app teams in their terraform:
    - [Gas Power Linux Standard VM](modules/gp_linux_standard)
    - [Gas Power Windows Standard VM](modules/gp_windows_standard)
- Linked you will find the module and its README which contains info on how it is used
- To reference any of these modules:
    - The source in the referenced terraform must be as follows:
        ```
        source = "git::https://github.build.ge.com/gp-azr-core/az-core-vm-provisioning.git//modules/MODULE?ref=RELEASE_REF"
        ```
    - The following providers must be included in your terraform file
        ```
            provider "azurerm" {
            subscription_id = var.subscription_id
            features {}
            }


            provider "azurerm" {
            alias = "gesos"
            subscription_id = "f28c99ba-3eac-470a-a3ee-fa026a3302d3" # DO NOT CHANGE
            skip_provider_registration = true
            features {}
            }

            provider "azurerm" {
            alias = "hub"
            subscription_id = "9c1ab385-2554-43ca-bdf8-f8d937bf4a28" # Use with East US
            #subscription_id = "4e02b754-b491-401d-b5c8-6e0f92663d8e" # Use with West Europe
            skip_provider_registration = true
            features {}
            }
        ```

### Troubleshooting
- Module Download
    - If running terraform locally in your app repository and not through an ADO pipeline, you may encounter this error:
        ```
        Error: Failed to download module
        │
        │ Could not download module "autonesting-vda-asg" (main.tf:9) source code from
        │ "git::https://github.build.ge.com/gp-azr-core/az-app-infra.git?ref=1.0": error downloading
        │ 'https://github.build.ge.com/gp-azr-core/az-app-infra.git?ref=1.0': C:\Program Files\Git\cmd\git.exe exited with 128:
        │ Cloning into '.terraform\modules\autonesting-vda-asg'...
        │ remote: Password authentication is not available for Git operations.
        │ remote: You must use a personal access token or SSH key.
        │ remote: See https://github.build.ge.com/settings/tokens or https://github.build.ge.com/settings/ssh
        │ fatal: unable to access 'https://github.build.ge.com/gp-azr-core/az-app-infra.git/': The requested URL returned error: 403
        ```
    - To fix this on Windows do the following:
        - Open Credentials Manager and click on Windows Credentials
        - Find the credential for git:https://github.build.ge.com
            - Make sure the username is your SSO
            - Set the password to a Github personal access token
- Provider Configuration Not Present
    - If trying to delete a vm and you get this error, make sure you have the following provider in your main.tf file
        ```
            provider "azurerm" {
                alias = "gesos"
                subscription_id = "8ce102f8-9ca3-4738-b6c2-fef8a062c578"
                skip_provider_registration = true
                features {}
            }
        ```

## Supported Images

### Windows

- GESOS-AZ-BASE-WINDOWS2012R2
- GESOS-AZ-BASE-WINDOWS2016
- GESOS-AZ-BASE-WINDOWS2019

## Linux

- GESOS-AZ-BASE-CENTOS7
- GESOS-AZ-BASE-ORACLELINUX7
- GESOS-AZ-BASE-RHEL7

## EVM Agents

Qualys, Splunk, and Crowdstrike are configured automatically for all of these VMs

## LDAP2FA - Linux

LDAP2FA is configured automatically with the provided ldap credentials, netgroup, and radius password

## Disk Mount

### Windows

All disk are mounted on the next available drive letter with the names "data<b>N</b>" where <b>N</b> is the disk number. These can be changed after VM creation.

### Linux

All disk are mounted at the provided disk mount directory with the names "data<b>N</b>" where <b>N</b> is the disk number. These can be changed after VM creation.

## Domain Join - Windows

The domain join scripts are copied to the VM and the VM is added to ARS. After the VM is created you will need to use the Azure portal's Run Command feature to finish the Domain Join setup. See the VM Deployment section for those instructions.

## Backup

All VMs are automatically added to the subscription level recovery vault and will use the provided backup policy.

## Patching

All VMs are automatically added to the 328 centralized Log Analytics Workspace to be enrolled in patching.

## Scripts

This terraform runs custom scripts on each VM to configure them according to Gas Power Standards. These scripts are stored in both centralized ops storage accounts in the common containers.

Note: All scripts under the vm folder are included in the github repository (except master scripts which are in the gp_ modules)

Required Container Layout:

    vm
        linux
            crowdstrike.sh
                Sets up Crowdstrike
            disk_mount.sh
                Mounts all of the disks at the provided base directory
            ldap2fa.sh
                Configures ldap with the provided ldap domain, password, netgroup, and radius password
            qualys.sh
                Sets up qualys
            splunk.sh
                Sets up splunk
        windows
            addcomputer.ps1
                Adds the computer to the domain
            addnetgroups.ps1
                Adds the netgroups after the domain is joined
            crowdstrike.ps1
                Sets up Crowdstrike
            disk_mount.ps1
                Mounts all of the disks
            domainjoin.ps1
                Adds the VM hostname to the ARS dashboard
            qualys.ps1
                Sets up qualys
            splunk.ps1
                Sets up splunk
    azure_bastion_config_files.zip
        Necessary files for ldap2fa
    CC_ActivClient-7.2_Win-x64.zip
        Enables SmartCard use. Backup in case this is not already installed on Windows VM
    falcon-sensor.el7.x86_64.rpm
        Crowdstrike rpm for Linux
    qualys-cloud-agent.x86_64_1.7.1.37.rpm
        Qualys Cloud Agent for Linux
    QualysCloudAgent.exe
        Qualys Cloud Agent for Windows
    splunkforwarder-7.1.1-8f0ead9ec3db-x64-release.msi
        Splunk Forwarder for Windows
    splunkforwarder-7.2.9.1-605df3f0dfdd-linux-2.6-x86_64.rpm
        Splunk Forwarder for Linux
    WindowsSensor_D96C92BDFB0946B589727FF82FB4601A-9E.exe
        Crowdstrike executable for Windows
