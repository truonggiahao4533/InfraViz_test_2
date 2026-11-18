# test 2

Designed in InfraViz. This repository holds configuration only: nothing here has been deployed by InfraViz.

## Environments

| Environment | Folder | State key |
|---|---|---|
| dev | `infra/envs/dev` | `dev.tfstate` |
| prod | `infra/envs/prod` | `prod.tfstate` |

Prod started as a copy of dev with prod names and prod scale. Change dev in InfraViz and promote the change to prod; prod changes always go through a pull request.

## Before the first apply

1. **State.** Each environment keeps its state in an Azure Storage blob container, one file per environment. Create the storage account and container once, then initialise each environment folder with them:

   ```sh
   terraform init \
     -backend-config="resource_group_name=<state resource group>" \
     -backend-config="storage_account_name=<state storage account>" \
     -backend-config="container_name=tfstate"
   ```

   Sign-in is with Entra ID (`use_azuread_auth`), so the people and pipelines that apply need *Storage Blob Data Contributor* on that container. Blob leases stop two applies from running at once.
2. **Subscription.** Set `TF_VAR_subscription_id` (or a `terraform.tfvars` file, which Git ignores) to the subscription of that environment.
3. **Resource providers.** `providers.tf` lists the Azure resource providers the design uses, and Terraform registers them. That needs permission to register providers on the subscription; if you do not have it, ask an owner to register them once.
4. **Lock file.** After the first `terraform init`, record the provider checksums for every platform your team uses and commit `.terraform.lock.hcl`:

   ```sh
   terraform providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64
   ```

## Container images

Container Apps start with a public placeholder image that listens on port 80. Push your images to the registry and set each app's image and ingress port in InfraViz. After that, new image versions are deployed by your pipeline: Terraform ignores later changes to the image, so an apply does not roll an app back.
