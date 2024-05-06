$path = "C:\ProgramData\Microsoft\Toast"
if(!(Test-Path $path))
{
	New-Item -Path $path -ItemType Directory
}
Copy-Item -Path "$($PSScriptRoot)\*" -Destination "C:\ProgramData\Microsoft\Toast" -Recurse -Force

schtasks.exe /create /tn "Toast" /xml "C:\ProgramData\Microsoft\Toast\toast.xml" /f