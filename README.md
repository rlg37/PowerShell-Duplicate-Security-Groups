# PowerShell-Duplicate-Security-Groups

Synchronizes members from one Microsoft 365 or Entra Security Group to another using the Microsoft Graph API. Members present in the source group but missing from the destination are added, and members in the destination that are not in the source are removed.

## Prerequisites

- PowerShell
- `Microsoft.Graph` and `Microsoft.Graph.Beta` modules (installed automatically if missing)
- An account with sufficient permissions to read and write group memberships

## Required Permissions

The script connects to Microsoft Graph with the `Group.ReadWrite.All` scope.

## Usage

1. Open [DuplicateSecurityGroups.ps1](DuplicateSecurityGroups.ps1) and set the two group variables near the top of the file:

   ```powershell
   $M365groupName = "GROUP 1"   # Source group (members are copied FROM this group)
   $SecGroupName  = "GROUP 2"   # Destination group (members are synced TO this group)
   ```

2. Run the script:

   ```powershell
   .\DuplicateSecurityGroups.ps1
   ```

3. Authenticate when prompted by the `Connect-Graph` login dialog.

## What the Script Does

1. **Installs dependencies** — Checks for the `Microsoft.Graph` module and installs it if not present.
2. **Connects to Graph** — Authenticates with `Group.ReadWrite.All` scope.
3. **Adds missing members** — Iterates over source group members and adds any that are not already in the destination group.
4. **Removes extra members** — Iterates over destination group members and removes any that are not present in the source group.

## Notes

- Group names must match exactly (case-sensitive filter is applied via `DisplayName eq`).
- The script outputs a message for each member added or removed.
