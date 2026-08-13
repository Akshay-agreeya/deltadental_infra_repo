# Delta Dental Infra

A **FastAPI** task-management REST API backed by **Azure SQL (Microsoft SQL Server)**, containerised with Docker, and deployed to **Azure Kubernetes Service (AKS)** via **ArgoCD**. Infrastructure is provisioned with **Terraform**.

---

## Repository Structure

```
.
├── app/                        # Application source code
│   ├── app.py                  # FastAPI application
│   ├── requirements.txt        # Python dependencies
│   ├── deplopyment_tem.yaml    # Deployment template
│   ├── service.yaml            # Kubernetes Service manifest
│   ├── manifest/               # Active Kubernetes manifests (watched by ArgoCD)
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── Add/                    # Add-task micro-service assets
│   ├── Micro/                  # Micro-UI assets
│   └── Readme.md               # Docker-run guide
├── argocd/
│   └── application.yaml        # ArgoCD Application definition
├── environments/
│   └── dev/                    # Dev environment Terraform root
│       ├── main.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── modules/                    # Reusable Terraform modules
│   ├── azurerm_resource_group/
│   ├── azurerm_acr/            # Azure Container Registry
│   ├── azurerm_aks/            # Azure Kubernetes Service
│   └── azurerm_Database/       # Azure SQL Database
├── SPEC.md                     # Full API & infrastructure specification
└── README.md                   # This file
```

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/` | Initialise DB — create `Tasks` table if it doesn't exist |
| `GET` | `/tasks` | List all tasks |
| `GET` | `/tasks/{task_id}` | Get a single task by ID |
| `POST` | `/tasks` | Create a new task |
| `PUT` | `/tasks/{task_id}` | Update an existing task |
| `DELETE` | `/tasks/{task_id}` | Delete a task |

### Task Schema

```json
{
  "id": 1,
  "title": "string (max 200 chars)",
  "description": "string"
}
```

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (for local development)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.0 (for infra provisioning)
- Azure CLI (`az`) with OIDC credentials
- `kubectl` + `kubelogin`
- An Azure subscription with permissions to create ACR, AKS, and SQL resources

---

## Local Development

### 1. Clone

```bash
git clone <repository_url>
cd deltadental_infra_repo
```

### 2. Configure the connection string

The app reads the database connection string from the `CONNECTION_STRING` environment variable.

```bash
export CONNECTION_STRING="Driver={ODBC Driver 17 for SQL Server};Server=tcp:<server>.database.windows.net,1433;Database=<db>;Uid=<user>;******;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
```

### 3. Run with Docker

```bash
cd app
docker build -t delta-dental-app .
docker run -p 8000:8000 -e CONNECTION_STRING="$CONNECTION_STRING" delta-dental-app
```

Access the API at `http://localhost:8000` and the auto-generated docs at `http://localhost:8000/docs`.

### 4. Run without Docker

```bash
cd app
pip install -r requirements.txt
uvicorn app:app --reload --port 8000
```

---

## Infrastructure (Terraform)

```
environments/dev/   ← Terraform root for the dev environment
  └─ calls modules:
       azurerm_resource_group   → Azure Resource Group
       azurerm_acr              → Azure Container Registry (ACR)
       azurerm_aks              → Azure Kubernetes Service cluster
       azurerm_Database         → Azure SQL Server + Database
```

### Provision dev environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

---

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/main.yaml`) runs on every push to `main`:

1. **Checkout** source code
2. **Azure Login** via OIDC (no long-lived secrets)
3. **Login to ACR**
4. **Build & push** `add-task` Docker image
5. **Build & push** `micro-ui` Docker image
6. **Update** `app/manifest/deployment.yaml` with the new image tag
7. **Commit & push** the updated manifest → triggers ArgoCD sync

---

## ArgoCD Deployment

`argocd/application.yaml` defines an ArgoCD `Application` that:

- Watches `app/manifest/` in this repository (`HEAD`)
- Automatically syncs (with `prune` and `selfHeal`) any manifest changes to AKS

To register the application with ArgoCD:

```bash
kubectl apply -f argocd/application.yaml -n argocd
```

---

## Configuration Reference

| Variable | Source | Description |
|----------|--------|-------------|
| `CONNECTION_STRING` | Env var / K8s secret | PyODBC connection string for Azure SQL |

---

## Contributing

1. Create a feature branch from `main`.
2. Make changes and run tests.
3. Open a pull request — the CI pipeline will validate your changes automatically.

---

## License

Internal use only — Delta Dental.
