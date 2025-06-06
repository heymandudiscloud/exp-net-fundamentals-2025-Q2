# Deploy Windows Server

```sh
az vm image list \
    --publisher MicrosoftWindowsDesktop \
    --offer "windows-11" \
    --location australiaeast \
    --all \
    --output table

az group create \
    --name net-fun-bootcamp \
    --location eastus

cd projects/ip_address_management/templates/vm
az deployment group create \
    --resource-group net-fun-bootcamp \
    --template-file template.bicep \
    --parameters @parameters.json \
    --debug
```