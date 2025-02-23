# Zabbix Agent Deployment Scripts

This repository contains scripts for deploying the Zabbix Agent on multiple machines. The scripts are designed to automate the installation process, making it easy to deploy the agent across multiple servers. These scripts can also be adapted to install other programs by modifying the relevant parts.

## Folder Structure

C:\Zabbix\            # Main folder  
│  
├── installer.ps1     # First installation script  
├── deploy.ps1        # Second script to deploy on multiple machines  
├── servers.txt       # File with the list of servers  
├── zabbix_agent2.msi # Zabbix agent installer file  

## Scripts Description

### `installer.ps1`

This script installs the Zabbix Agent on a single machine. It performs the following tasks:
1. Checks if the Zabbix Agent is already installed.
2. Installs the Zabbix Agent using the provided MSI file.
3. Pauses for 60 seconds to ensure the installation is complete.
4. Retrieves the fully qualified domain name (FQDN) of the machine.
5. Modifies the configuration file to include the FQDN.
6. Starts the Zabbix Agent service and sets it to start automatically.
7. Adds a firewall exception for the Zabbix Agent.

### `deploy.ps1`

This script deploys the Zabbix Agent on multiple machines listed in `servers.txt`. It performs the following tasks:
1. Reads the list of servers from `servers.txt`.
2. Copies the Zabbix Agent MSI file to each server.
3. Sets the execution policy on each server.
4. Runs the `installer.ps1` script on each server to install the agent.
5. Closes the remote PowerShell session.

### `servers.txt`

A text file containing the list of servers where the Zabbix Agent will be installed. Each line should contain the hostname or IP address of a server.

Example:

192.168.1.100  
192.168.1.101  
192.168.1.102  

### `zabbix_agent2.msi`

The MSI installer file for the Zabbix Agent.

## Customization for Other Programs

To adapt these scripts for installing other programs, follow these steps:
1. Replace the `zabbix_agent2.msi` file with the installer for the desired program.
2. Modify the installation commands in `installer.ps1` to match the installation requirements of the new program.
3. Update the paths and any other relevant details in both scripts to reflect the new program.

## Usage

1. Ensure that all the files are placed in the `C:\Zabbix\` directory.
2. Populate `servers.txt` with the list of target servers.
3. Run `deploy.ps1` to deploy the Zabbix Agent on all listed servers.

## License

This project is licensed under the MIT License.
