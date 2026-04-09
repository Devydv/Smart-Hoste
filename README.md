# Smart Hostel Final - DevOps Enabled

This project now includes a complete DevOps starter setup using:

- Git and GitHub workflow
- Docker and Docker Compose
- GitHub Actions CI
- Jenkins pipeline
- Terraform infrastructure templates
- Ansible deployment playbook
- Kubernetes manifests

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
- `devops/sql/init.sql`

## 3) Git + GitHub Suggested Workflow

```bash
git checkout -b feature/devops-setup
git add .
git commit -m "Add DevOps setup: Docker, CI, Terraform, Ansible, Kubernetes, Jenkins"
git push origin feature/devops-setup
```

Then create a Pull Request to `dev` or `main`.

## 4) GitHub Actions (CI)

Workflow file:

- `.github/workflows/ci.yml`

Pipeline stages:

1. Install dependencies
2. Lint with Ruff
3. Run pytest
4. Build Docker image
5. Trivy scan

Trigger:

- Push to `main` or `dev`
- Any pull request

## 5) Jenkins Pipeline

Pipeline file:

- `Jenkinsfile`

Stages included:

1. Checkout
2. Install dependencies
3. Lint and tests
4. Docker image build
5. Trivy image scan

To use Jenkins:

1. Create a Pipeline job
2. Connect GitHub repository
3. Set pipeline script from SCM
4. Build job

## 6) Terraform (Infrastructure as Code)

Folder:

- `terraform/`

Files:

- `providers.tf`
- `variables.tf`
- `main.tf`
- `outputs.tf`
- `terraform.tfvars.example`

Usage:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with real IDs
terraform init
terraform plan
terraform apply
```

This provisions:

- Security Group
- EC2 instance for app deployment

## 7) Ansible (Server Configuration + Deployment)

Folder:

- `ansible/`

Files:

- `inventory.ini.example`
- `deploy.yml`

Usage:

```bash
cd ansible
cp inventory.ini.example inventory.ini
# Edit host IP and key path
ansible-playbook -i inventory.ini deploy.yml
```

Playbook actions:

1. Install Docker and dependencies
2. Clone project repository
3. Run `docker compose up -d --build`

## 8) Kubernetes

Folder:

- `k8s/`

Includes:

- Namespace
- MySQL secret template
- MySQL init SQL ConfigMap
- MySQL PVC, Deployment, Service
- App ConfigMap + Secret template
- App Deployment + NodePort Service

Usage:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mysql-secret.example.yaml
kubectl apply -f k8s/mysql-init-configmap.yaml
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml
kubectl apply -f k8s/app-secret.example.yaml
kubectl apply -f k8s/app-configmap.yaml
```

Before applying app deployment, set real image name in `k8s/app-deployment.yaml`:

```yaml
image: YOUR_DOCKERHUB_USERNAME/smart-hostel:latest
```

Then apply:

```bash
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-service.yaml
kubectl get svc -n smart-hostel
```

App URL (NodePort):

`http://<node-ip>:30080`

## 9) Recommended Submission Demo Flow

1. Show local run with Docker Compose
2. Push code and show GitHub Actions CI pass
3. Show Jenkins pipeline stages
4. Show Terraform plan/apply output
5. Show Ansible deployment output
6. Show Kubernetes pods/services running

## 10) Security Notes

- Do not commit real cloud credentials.
- Replace example secrets before production use.
- Use GitHub Secrets for CI/CD credentials.
