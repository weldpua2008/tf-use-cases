### Prerequisites

1. `az group create --name tfstate --location eastus2`
2. 
```shell
az storage account create \
    --name tfeastus2tfusecase \
    --resource-group tfstate \
    --location eastus2 \
    --sku Standard_LRS
```
3. 
```shell
az storage container create \
        --name tstate \
        --account-name tfeastus2tfusecase

```
