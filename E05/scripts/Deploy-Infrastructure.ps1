param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter()]
    [string]$Validate
)

$timestamp = Get-Date -Format "yyyyMMddHHmmss"

$isValidationOnly = $Validate -eq "true"

$params = @{
    Name                  = "app-$timestamp"
    ResourceGroupName     = $resourceGroupName
    TemplateFile          = './templates/app.bicep'
    TemplateParameterFile = './templates/app.bicepparam'
    Mode                  = "Complete"
    WhatIf                = $isValidationOnly
    Force                 = !$isValidationOnly
}

New-AzResourceGroupDeployment @params
