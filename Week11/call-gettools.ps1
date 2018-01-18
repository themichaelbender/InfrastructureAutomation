    function Get-OSInfo {
        param(
            [string]$computerName = 'localhost'
        )
        
        Get-CimInstance -ClassName Win32_OperatingSystem `
        -ComputerName $computerName

    }






    Get-OSinfo -computerName PS1
