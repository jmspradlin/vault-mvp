# Packer Vault image creation

Use the packer-vault.json file to create a Vault Azure image.

Define your secrets using a `packer-secret.json` file as follows:

```
{
    "client-id": "SERVICE-PRINCIPAL-CLIENT-ID",
    "client-secret": "SERVICE-PRINCIPAL-CLIENT-SECRET",
    "tenant-id": "AZURE-TENANT-ID",
    "subscription-id": "AZURE-SUBSCRIPTION-ID"
}
```

Run the packer file with 
```
packer build /
-var 'managed-image-name=AZURE-IMAGE-NAME' /
-var-file=packer-secrets.json /
packer-vault.json
```