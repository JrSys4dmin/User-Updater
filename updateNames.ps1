## search AD for all users containing Henry
$Accounts = Get-ADUser -LDAPFilter "(&(objectCategory=person)(displayName=*Test*)(displayName=*))" -Properties *
$Table = @()
$AccountInfo = [ordered]@{
    "UPN"=""
    "FN" =""
	"LN"=""
	"SID"=""
    }
#loop through all the users and move theinfo to an array
ForEach ($Account in $Accounts) 
    {    
        $AccountInfo."UPN" = $Account.sAMAccountName
        $AccountInfo."FN" = $Account.GivenName
	    $AccountInfo."LN" = $Account.Surname
	    $AccountInfo."SID" = $Account.DisplayName
	    $objRecord  = New-Object PSObject -property $AccountInfo
	    $Table += $objRecord
	}
##for verification purpose, write out the Student IDs that will be affected
<#
clear-Host
foreach	($Result in $Table) 
    {
        Write-Host  $Result.UPN "will have data changed in this process"
    }
#>

##loop through each resulting user and move 
foreach ($Result in $Table) {
    $NEWTitle = $Result.SID
    $NEWFname = $Result.FN
    $NewLName = $result.LN
    Set-ADUser -Identity $Result.UPN -Title "Student - $NEWTitle" -DisplayName "$NewFName $NewLName"
    
}

