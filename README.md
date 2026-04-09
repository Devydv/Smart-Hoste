# Smart Hostel Final - DevOps Enabled

This project now includes a complete DevOps starter setup using:

- Git and GitHub workflow
- Docker and Docker Compose
- GitHub Actions CI/CD
- Terraform infrastructure templates
- Ansible deployment playbook
- Kubernetes manifests

## Project Structure

```text
smart_hostel_final/
├── .github/workflows/      # GitHub Actions CI
├── infra/
│   ├── ansible/            # Deployment automation
│   ├── k8s/                # Kubernetes manifests
│   ├── sql/                # MySQL init schema/data
│   └── terraform/          # Infrastructure as Code
├── static/                 # Frontend assets
├── templates/              # Flask templates
├── tests/                  # Test suite
├── app.py                  # Flask app entry
├── db.py                   # DB connection helper
├── docker-compose.yml
└── Dockerfile
```

## 1) Local Run (Python)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open: http://127.0.0.1:5000

## 2) Docker and Docker Compose

Run the full stack (Flask + MySQL):

```bash
docker compose up -d --build
```

Open: http://127.0.0.1:5000

Stop:

```bash
docker compose down
```

Files used:

- `Dockerfile`
- `docker-compose.yml`
- `infra/sql/init.sql`

## 3) Git + GitHub Suggested Workflow

```bash
git checkout -b feature/devops-setup
git add .
git commit -m "Add DevOps setup: Docker, CI, Terraform, Ansible, Kubernetes"
git push origin feature/devops-setup
```

Then create a Pull Request to `dev` or `main`.

## 4) GitHub Actions (CI/CD)

Workflow file:

- `.github/workflows/ci.yml`

Pipeline stages:

1. Install dependencies
2. Lint with Ruff
3. Run pytest
4. Build Docker image
5. Trivy scan
6. Deploy to EC2 with Ansible (on push to main)
7. Post-deploy health check

Trigger:

- Push to `main` or `dev`
- Any pull request

### Required GitHub Secrets for CD

Set these in your repository: Settings -> Secrets and variables -> Actions.

1. `EC2_HOST` - EC2 public IP or DNS
2. `EC2_USER` - SSH user (for Ubuntu AMI: `ubuntu`)
3. `EC2_SSH_PRIVATE_KEY` - Full private key content for the EC2 key pair

## 5) Terraform (Infrastructure as Code)

Folder:

- `infra/terraform/`

Files:

- `providers.tf`
- `variables.tf`
- `main.tf`
- `outputs.tf`
- `terraform.tfvars.example`
- `backend.hcl.example`

### One-Time Remote State Setup (Recommended)

Use Terraform bootstrap to create S3 remote state and DynamoDB locking:

```bash
cd infra/terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
terraform output backend_hcl_snippet
```

IAM permissions required for this bootstrap step:

1. `s3:CreateBucket`
2. `s3:PutBucketVersioning`
3. `s3:PutEncryptionConfiguration`
4. `s3:PutBucketPublicAccessBlock`
5. `dynamodb:CreateTable`

Copy output values into main backend config:

```bash
cd ../
cp backend.hcl.example backend.hcl
# Paste bucket/table values from bootstrap output
terraform init -migrate-state -backend-config=backend.hcl
```

Usage:

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with real IDs
terraform init
terraform plan
terraform apply
```

This provisions:

- Security Group
- EC2 instance for app deployment

## 6) Ansible (Server Configuration + Deployment)

Folder:

- `infra/ansible/`

Files:

- `inventory.ini.example`
- `deploy.yml`

Usage:

```bash
cd infra/ansible
cp inventory.ini.example inventory.ini
# Edit host IP and key path
ansible-playbook -i inventory.ini deploy.yml
```

Playbook actions:

1. Install Docker and dependencies
2. Clone project repository
3. Run `docker compose up -d --build`

## 7) Kubernetes

Folder:

- `infra/k8s/`

Includes:

- Namespace
- MySQL secret template
- MySQL init SQL ConfigMap
- MySQL PVC, Deployment, Service
- App ConfigMap + Secret template
- App Deployment + NodePort Service

Usage:

```bash
kubectl apply -f infra/k8s/namespace.yaml
kubectl apply -f infra/k8s/mysql-secret.example.yaml
kubectl apply -f infra/k8s/mysql-init-configmap.yaml
kubectl apply -f infra/k8s/mysql-pvc.yaml
kubectl apply -f infra/k8s/mysql-deployment.yaml
kubectl apply -f infra/k8s/mysql-service.yaml
kubectl apply -f infra/k8s/app-secret.example.yaml
kubectl apply -f infra/k8s/app-configmap.yaml
```

Before applying app deployment, set real image name in `infra/k8s/app-deployment.yaml`:

```yaml
image: YOUR_DOCKERHUB_USERNAME/smart-hostel:latest
```

Then apply:

```bash
kubectl apply -f infra/k8s/app-deployment.yaml
kubectl apply -f infra/k8s/app-service.yaml
kubectl get svc -n smart-hostel
```

App URL (NodePort):

`http://<node-ip>:30080`

## 8) Recommended Submission Demo Flow

1. Show local run with Docker Compose
2. Push code and show GitHub Actions CI pass
3. Show GitHub Actions CD deployment to EC2
4. Show Terraform plan/apply output
5. Show Ansible deployment output
6. Show Kubernetes pods/services running

## 9) Security Notes

- Do not commit real cloud credentials.
- Replace example secrets before production use.
- Use GitHub Secrets for CI/CD credentials.
