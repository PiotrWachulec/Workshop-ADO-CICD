# \[Workshop\] Bicep Infrastructure Developer

## Requirements

- VS Code
- VS Code extensions:
    - Bicep
    - Azure Resource Manager (ARM) Tools
    - Powershell
- Azure CLI version 2.53.0 or newer
- Bicep CLI version 0.22.6 or higher
- Powershell Core 7.2 or higher

## Workshop

### Preparation

#### Key concepts:
    
- [Key concepts for new Azure Pipelines users](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops)
- Jobs run on agents, so you cannot use different agents for tasks, but you can run jobs on different types of agents. Also, you can choose agent types for Stages.
- Continuous Integration vs Continuous Deployment vs Continuous Delivery concepts

### Create service connection for pipeline

1. Connect ADO to Azure tenant
    - https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/change-azure-ad-connection?view=azure-devops
2. Create Workload identity service connection twice for `dev` and `prod` deployments
    - https://devblogs.microsoft.com/devops/public-preview-of-workload-identity-federation-for-azure-pipelines/
    - https://techcommunity.microsoft.com/t5/azure-devops-blog/introduction-to-azure-devops-workload-identity-federation-oidc/ba-p/3908687
3. Issue with authentication to Container Registry
4. https://github.com/Azure/bicep/discussions/11840

### \[E01\] Setup basic pipeline

1. Create file `pipelines/deploy-infra.yaml`
2. Add the below content to the file
    
    ```json
    pool:
        vmImage: 'ubuntu-latest'
    
    steps:
        - script: |
            echo "Hello"
            echo "World!"
    ```
    
3. Commit and push the file
4. Create the pipeline from file and run

### \[E02\] Add running PS script for deploying to `dev` resource group
    
```yaml
- task: AzurePowerShell@5
    inputs:
        azureSubscription: 'Training-DEV-SCN'
        ScriptType: 'FilePath'
        ScriptPath: './scripts/Deploy-Infrastructure.ps1'
        ScriptArguments: '-ResourceGroupName "pw-bicep-ado-training-dev"'
        azurePowerShellVersion: 'OtherVersion'
        preferredAzurePowerShellVersion: 10.3.0
        pwsh: true
        workingDirectory: '$(Build.SourcesDirectory)'
```
    
### \[E03\] Extract variable fields to variables

1. https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#specify-variables
2. If you are using only variables in file, the below syntax is also valid:
    
    ```yaml
    variable:
        <variable_name>: <variable_value>
    ```
        
### \[E04\] Wrap task into job
### \[E05\] Expand script to have possibility to validate the deployment with `-WhatIf`

1. https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-what-if?tabs=azure-powershell 
2. Use Splatting to extract parameter from command
3. Variables in Pipelines are passed as strings

### \[E06\] Add separated job for deployment validation

1. Remember about dependency between jobs

### \[E07\] Extract deployment task to the template

### \[E08\] Wrap jobs into stages

### \[E09\] Add:

1. Separated parameter files for production and development and regions Poland Central and West Europe (file name: `app.<region>.<env>.bicepparam`)
2. Related resource groups in format `***-<region>-<env>-rg`
3. Possibility to override Location during deployment

### \[E10\] Add matrix deployment for regions and environments

1. Define multi-job configuration
    - https://learn.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml#multi-job-configuration
2. Update script to generate resource group name based on parameters

### \[E11\] Add stages for validation and deployment for production

1. For `main` branch the deployments for dev and prod should run in parallel