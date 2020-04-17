<#
    Powershell Lab 7
    User-OUs-Groups with Menu
    Date: Apr 11 2020
    User: Vonscher Schiung
#>
 cls

 $Choose = @"
Choose from the following Menu Items:
    A. VIEW one OU         B. VIEW all OUs
    C. VIEW one group      D. VIEW all groups
    E. VIEW one user       F. VIEW all users
    

    G. CREATE one OU       H. CREATE one group
    I. CREATE one user     J. CREATE users from CSV file


    K. Add user to group   L. Remove user from group


    M. DELETE one group    N. DELETE one user


    Enter anything than A - N to quit 
"@
 $Choose
 $Choice = Read-Host "Choose a menu letter"

if($Choice -eq "A"){
    $OU = Read-Host "Name of the OU to View"
    Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" -Properties * | ft -Property Name,distinguishedName
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "B"){
    Get-ADOrganizationalUnit -Filter "Name -ne 'Domain Controllers'" -Properties * | ft -Property name, distinguishedname
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "C"){
     $Group = Read-Host "Name of the group to view"
     Get-ADGroup -Identity "$Group" | ft -Property Name, groupscope, groupcategory
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "D"){
     Get-ADGroup -Filter * |ft -Property Name, groupscope, groupcategory
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "E"){
     $User = Read-Host "Name of the User to view"
     Get-ADUser -Identity $User | ft -Property Name, distinguishedname
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "F"){
     Get-ADUser -Filter * | ft -Property Name, distinguishedname,GivenName, Surname
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "G"){
     $NOU = Read-Host "Name of a OU to Create"
     New-ADOrganizationalUnit -Name $NOU -ProtectedFromAccidentalDeletion $false
     Get-ADOrganizationalUnit -Filter "Name -eq '$NOU'" | ft -Property Name, distinguishedName
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "H"){
    $NGroup = Read-Host " Name of the group to create"
     New-ADGroup -Name $NGroup -GroupCategory Security -GroupScope Global
     Get-ADGroup -Identity "$NGroup" | ft -Property Name, GroupScope, GroupCategory
     Read-Host "Press enter to continue"
}
elseif($Choice -eq "I"){
    $name = Read-Host "Name of the User to Create"
    $pass = Read-Host "Password"
    $pwd = ConvertTo-SecureString -string $pass -AsPlainText -Force

    $first = Read-Host "$name's first name?"
    $last = Read-Host "$name's last name?"
    $Zip = Read-Host "$name's Zipcode"
    $city = Read-Host "$name's city?"
    $state = Read-Host "$name's state?"
    $Comp = Read-Host "$name's Company"
    $Div = Read-Host "$name's Division"

    $userParams = @{Name = $name
        SamAccountName    = $name
        UserPrincipalName = "$name@adatum.com"
        GivenName         = $first
        Surname           = $last
        City              = $city
        PostalCode        = $Zip
        State             = $state
        Company           = $Comp
        Division          = $Div
    }
    $userParams
    $Con = @"
        Choose where should the New User go into
            A. Users container     B. Into an OU 
"@
    $Con
    $Cons = Read-Host " Where should the New user go into"
        if($Cons -eq "A"){
            New-ADUser @UserParams -AccountPassword $pwd
        }
        elseif($Cons -eq "B"){
            $Path = Read-Host "Name the path of the OU"
            New-ADUser @UserParams -Path "$Path"
        }
    Get-ADUser -Identity $name -Properties * | ft Name, SamAccountName, UserPrincipalName,  GivenName, Surname, City, State, PostalCode, Company, Division
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "J"){
    $CSV = Read-Host "Name of the CSV file"
    $Pwds = Read-Host "Password for all User"
    $pds = (ConvertTo-SecureString -String $Pwds -AsPlainText -Force)

    $users = Import-Csv -path C:\Users\Administrator\Desktop\$CSV

    $users | New-ADUser -AccountPassword $pds -Enabled $true
   
    Get-ADUser -Filter * -Properties * | ft Name,SamAccountName,UserPrincipalName,City,State,GivenName,Surname,PostalCode,Company,Division
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "K"){
    $Gp = Read-Host "Name of the Group that will gain a User"
    $Us = Read-Host "Name the User to add the Group"
    Add-ADGroupMember -Identity "$Gp" -Members $Us
    Get-ADGroupMember -Identity $Gp | ft SamAccountName,DistinguishedName
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "L"){
    $Gp = Read-Host "Name of group to remove the User"
    Get-ADGroupMember -Identity $Gp | ft SamAccountName,DistinguishedName
    $Rm = Read-Host "One of those User should be remove from the group Y|N"
        if($Rm -eq "Y"){
            $user = Read-Host "Name of the User wish to Remove "
            Remove-ADGroupMember -Identity "$Gp" -Members $user
            Get-ADGroupMember -Identity $Gp | ft SamAccountName,DistinguishedName
           } 
    Read-Host "Press enter to continue"
}
elseif($Choice -eq "M"){
        $Gp = Read-Host "Name of the group wish to delete"
        Remove-ADGroup -Identity "$Gp"
        Get-ADGroup -Filter * -Properties * | ft -Property Name,GroupScope,GroupCategory
        Read-Host "Press enter to continue"
}
elseif($Choice -eq "N"){
$User = Read-Host "Name the User wish to Delete"
Remove-ADUser -Identity "$User"
Get-ADUser -Filter * -Properties * |ft -Property Name,DistinguishedName
Read-Host "Press enter to continue"
 }
