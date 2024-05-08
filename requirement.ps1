$process = Get-Process -Name SecurityHealthsystray -ErrorAction SilentlyContinue

# If process is not found, we're not in OOBE (Out-of-Box-Experience)
if($process -ne $null)
{
  Write-Output "not-OOBE"
  exit 0
}
else
{
  # If process IS null, we are in OOBE
  Write-Output "OOBE"
  exit 0
}
