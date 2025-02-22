param (
    [string]$zabbixServerIP
)

# Check if any Zabbix service is installed
$zabbixService = Get-Service -Name "*zabbix*" -ErrorAction SilentlyContinue

if ($null -ne $zabbixService) {
    Write-Output "Zabbix Agent is already installed."
} else {
    # Install the Zabbix agent
    Start-Process msiexec.exe -ArgumentList "/i c:\zabbix_agent2.msi /quiet /norestart SERVER=$zabbixServerIP /log C:\zabbix_install.log" -Wait

    # Pause for 60 seconds after installation
    Start-Sleep -Seconds 60

    # Get the FQDN of the hostname
    $FQDN = ([System.Net.Dns]::GetHostEntry($env:COMPUTERNAME)).HostName

    # Read and modify the configuration file
    $configPath = "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf"

    if (Test-Path $configPath) {
        $configContent = Get-Content -Path $configPath

        # Add logging for debugging
        Write-Output "Original file content:"
        Write-Output $configContent

        # Modify necessary lines
        $configContent = $configContent -replace '^#\s*Hostname\s*=\s*.*', "Hostname=$FQDN"

        # Save the modified file
        Set-Content -Path $configPath -Value $configContent

        # Check the output of the modified file
        $updatedContent = Get-Content -Path $configPath
        Write-Output "Updated file content:"
        Write-Output $updatedContent
    } else {
        # Create the file if it doesn't exist
        Set-Content -Path $configPath -Value @"
Hostname=$FQDN
"@
    }

    # Start the Zabbix agent service
    Start-Service -Name "Zabbix Agent 2"
    Set-Service -Name "Zabbix Agent 2" -StartupType Automatic

    # Add Zabbix agent exception to the firewall
    New-NetFirewallRule -DisplayName "Zabbix Agent 2" -Direction Inbound -Program "C:\Program Files\Zabbix Agent 2\zabbix_agent2.exe" -Action Allow

    # Verify installation
    Get-Service "*Zabbix Agent*"
}
