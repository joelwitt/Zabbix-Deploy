# Read the list of servers from a file
$servers = Get-Content -Path "C:\path\to\servers.txt"
$localInstallerPath = "C:\path\to\zabbix_agent2.msi"
$scriptPath = "C:\path\to\installer.ps1"
$zabbixServerIP = "YOUR_ZABBIX_SERVER_IP"

foreach ($server in $servers) {
    $destinationPath = "\\$server\c$\zabbix_agent2.msi"

    # Create a remote PowerShell session
    $session = New-PSSession -ComputerName $server

    # Try to copy the MSI file to the remote machine
    try {
        Write-Output "Copying $localInstallerPath to $destinationPath"
        Copy-Item -Path $localInstallerPath -Destination $destinationPath -Force -ErrorAction Stop
        Write-Output "File successfully copied to $server"
    } catch {
        Write-Error "Error copying the file to $server : $_"
        continue
    }

    # Set execution policy
    Invoke-Command -Session $session -ScriptBlock { Set-ExecutionPolicy Bypass -Force }

    # Check the execution policy
    $executionPolicy = Invoke-Command -Session $session -ScriptBlock { Get-ExecutionPolicy }
    Write-Output "Execution Policy on $server : $executionPolicy"

    # Run the installation script
    Invoke-Command -Session $session -FilePath $scriptPath -ArgumentList $zabbixServerIP

    # Close the session
    Remove-PSSession -Session $session
}
