##################################################################
###############INSTALL PACKAGES BELOW#############################
##################################################################


if (Get-InstalledModule -Name Microsoft.Graph) {
    Write-Host "Package Already Installed"
}
else {
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
    Write-Host "Packages Installed"
}

Connect-Graph -Scopes Group.ReadWrite.All 

##################################################################
##########INSERT M365 OR SEC GROUPS BELOW ########################
##################################################################
#####WE ARE COPYING MEMBERS FROM GROUP 1 OVER TO GROUP 2##########

$M365groupName = "GROUP 1"
$SecGroupName  = "GROUP 2"

# Get group IDs
$M365Group = Get-MgGroup -Filter "DisplayName eq '$M365GroupName'"
$SecGroup  = Get-MgGroup -Filter "DisplayName eq '$SecGroupName'"

# Get members of each group
$M365Users = @(Get-MgGroupMember -GroupId $M365Group.Id)
$SecUsers  = @(Get-MgGroupMember -GroupId $SecGroup.Id)

#################################################################
##############ADD MEMBERS FROM M365 to SEC#######################
#################################################################

# Add missing members
foreach ($Member in $M365Users) {

    if ($SecUsers.Id -contains $Member.Id) {
        # User Exists
    }
    else {
        $newGroupMember = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($Member.Id)"
        }

        New-MgGroupMemberByRef -GroupId $SecGroup.Id -BodyParameter $newGroupMember
        Write-Output "Added $($Member.Id) to $SecGroupName"
    }
}

#################################################################
###############REMOVE MEMBERS FROM SEC IF NOT IN M365############
#################################################################

# Remove extra members
foreach ($SecMember in $SecUsers) {

    if ($M365Users.Id -contains $SecMember.Id) {
        #User Exists
    }
    else {
        Remove-MgGroupMemberByRef -GroupId $SecGroup.Id -DirectoryObjectId $SecMember.Id
        Write-Output "Removed $($SecMember.Id) from $SecGroupName"
    }
}

