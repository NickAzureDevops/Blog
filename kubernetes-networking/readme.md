create aks 

az aks create \
    --resource-group test \
    --name aks-test \
    --node-count 2 \
    --enable-addons http_application_routing \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --network-plugin azure

create userpool instead of using default system node pool

    az aks nodepool add \
    --resource-group $RESOURCE_GROUP \
    --cluster-name aks-cluster-dev \
    --name userpool \
    --node-count 2 \
    --node-vm-size Standard_B2s


az aks show \
  -g g-cluster \
  -n aks-cluster-dev  \
  -o tsv \
  --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName


clean up

kubectl config delete-context aks-contoso-video


