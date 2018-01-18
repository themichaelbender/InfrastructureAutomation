param(
  [parameter(Mandatory = $true)]
  [string] $Path,
  [parameter(Mandatory = $true)]
  [string] $Name 
  )
$System = [Environment]::GetFolderPath("System")
$script:hostsPath = ([System.IO.Path]::Combine($System, "drivers\etc\"))+"hosts"

function New-localWebsite([string] $sitePath, [string] $siteName)
{
 try
 {
  Import-Module WebAdministration
 }
 catch 
 {
  Write-Host "IIS Powershell module is not installed. Please install it first, by adding the feature"
 }
 Write-Host "AppPool is created with name: " $siteName
 New-WebAppPool -Name $siteName 
 Set-ItemProperty IIS:\AppPools\$Name managedRuntimeVersion v4.0
 Write-Host 
 if(-not (Test-Path $sitePath))
 {
  New-Item -ItemType Directory $sitePath
 }
 $header = "www."+$siteName+".local"
 $value = "127.0.0.1 " + $header
 New-Website -ApplicationPool $siteName -Name $siteName -Port 80 -PhysicalPath $sitePath -HostHeader ($header) 
 Start-Website -Name $siteName
 if(-not (HostsFileContainsEntry($header)))
 {
  AddEntryToHosts -hostEntry $value  
 } 
 
}

function AddEntryToHosts([string] $hostEntry)
{
 try
 {
  $writer = New-Object System.IO.StreamWriter($hostsPath, $true)
  $writer.Write([Environment]::NewLine)
  $writer.Write($hostEntry)
  $writer.Dispose()
 }
 catch [System.Exception]
 {
  Write-Error "An Error occured while writing the hosts file"
 }
 
}

function HostsFileContainsEntry([string] $entry)
{ 
 try
 {
  $reader = New-Object System.IO.StreamReader($hostsPath + "hosts")
  while(-not($reader.EndOfStream))
  {
   $line = $reader.Readline()
   if($line.Contains($entry))
   {
    return $true
   }
  }
  return $false
 }
 catch [System.Exception]
 {
  Write-Error "An Error occured while reading the host file"
 }
}

New-localWebsite -sitePath C:\Website\website.htm -siteName DemoWebsite