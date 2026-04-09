# Terraform Remote State Bootstrap

This folder creates backend infrastructure for Terraform state:

- S3 bucket for remote state
- DynamoDB table for state locking

## Usage

```bash
cd infra/terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
terraform output backend_hcl_snippet
```

Then in `infra/terraform`:

```bash
cp backend.hcl.example backend.hcl
# paste values from backend_hcl_snippet
terraform init -migrate-state -backend-config=backend.hcl
```
