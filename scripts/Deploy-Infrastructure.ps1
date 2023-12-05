param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupNamePrefix,
    [Parameter()]
    [string]$Validate,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [Parameter(Mandatory = $true)]
    [string]$Environment
)

$timestamp = Get-Date -Format "yyyyMMddHHmmss"

$isValidationOnly = $Validate -eq "true"

$ResourceGroupName = "$ResourceGroupNamePrefix-$Location-$Environment-rg"

$params = @{
    Name                  = "app-$timestamp"
    ResourceGroupName     = $resourceGroupName
    TemplateFile          = "./templates/app.bicep"
    TemplateParameterFile = "./templates/app.$Location.$Environment.bicepparam"
    Mode                  = "Complete"
    WhatIf                = $isValidationOnly
    Force                 = !$isValidationOnly
    location              = $Location
}

New-AzResourceGroupDeployment @params
