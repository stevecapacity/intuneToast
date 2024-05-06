$modules = @(
	'BurntToast'
	'RunAsUser'
)

foreach($module in $modules)
{
	$installed = Get-InstalledModule -Name $module
	if(-not($installed))
	{
		try 
		{
			Install-Module -Name $module -Confirm:$false -Force
			Import-Module $module			
		}
		catch 
		{
			$message = $_
			Write-Host "Error installing $($module): $message"
		}
	}
	else 
	{
		Import-Module $module
		Write-Host "$($module) already installed."
	}
}

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT -ErrorAction SilentlyContinue | Out-Null
$ProtocolHandler = get-item 'HKCR:\CompanyPortal' -ErrorAction SilentlyContinue
if(!$ProtocolHandler)
{
	New-item 'HKCR:\CompanyPortal' -Force
	Set-ItemProperty 'HKCR:\CompanyPortal' -name '(DEFAULT)' -value 'url:CompanyPortal' -force
	Set-ItemProperty 'HKCR:\CompanyPortal' -name 'URL Protocol' -value '' -force
	New-ItemProperty -Path 'HKCR:\CompanyPortal' -PropertyType dword -Name 'EditFlags' -value 2162688
	new-item 'HKCR:\CompanyPortal\Shell\Open\command' -force
	Set-ItemProperty 'HKCR:\CompanyPortal\Shell\Open\command' -Name '(DEFAULT)' -value 'shell:appsFolder\Microsoft.CompanyPortal_8wekyb3d8bbwe!App' -Force
}

$codeBlock = 
{
	$text1 = New-BTText -Text "Welcome!"
	$text2 = New-BTText -Text "You're PC will be ready soon.  In the meantime, click below to see the apps available to you."
	$hero =  New-BTImage -Source "C:\ProgramData\Microsoft\Toast\hero.jpeg" -HeroImage
	$logo = New-BTImage -Source "C:\ProgramData\Microsoft\Toast\logo.jpeg" -AppLogoOverride
	$button1 = New-BTButton -Content "Browse apps" -Arguments "CompanyPortal:" -ActivationType Protocol
	$button2 = New-BTButton -Dismiss -Content "Dismiss"
	$action = New-BTAction -Buttons $button1, $button2
	$binding = New-BTBinding -Children $text1, $text2 -HeroImage $hero -AppLogoOverride $logo
	$visual = New-BTVisual -BindingGeneric $binding
	$content = New-BTContent -Visual $visual -Actions $action
	Submit-BTNotification -Content $content
}
    
Invoke-AsCurrentUser -ScriptBlock $codeBlock -UseWindowsPowerShell

Disable-ScheduledTask -TaskName "Toast" -ErrorAction SilentlyContinue