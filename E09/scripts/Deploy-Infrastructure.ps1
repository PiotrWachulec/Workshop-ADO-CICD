param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter()]
    [string]$Validate,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [Parameter(Mandatory = $true)]
    [string]$Environment
)

$timestamp = Get-Date -Format "yyyyMMddHHmmss"

$isValidationOnly = $Validate -eq "true"

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
