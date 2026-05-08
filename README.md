# Weather API on AWS EKS (Fargate)

A .NET 8 Web API deployed to AWS EKS using Fargate, provisioned with Terraform, and containerized with Docker.

## Architecture

- **.NET 8 Web API** with Swagger UI and health checks
- **Docker** multi-stage build for optimized images
- **GitHub Actions** CI/CD pipeline for building and pushing images
- **Terraform** provisions VPC, EKS cluster, and Fargate profile
- **Kubernetes** manifests for deployment and LoadBalancer service
- **AWS NLB** provides public access via DNS name

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5.0
- kubectl
- Docker (for local testing)
- AWS IAM permissions to create EKS, VPC, and IAM resources

## Step 1 — Configure AWS CLI

```bash
aws configure
# Enter your Access Key ID, Secret Access Key, region (e.g. us-east-1), and output format (json)
```

## Step 2 — Deploy Infrastructure with Terraform

```bash
cd infra/terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply (creates VPC, EKS cluster, Fargate profile — takes ~15 minutes)
terraform apply
```

## Step 3 — Configure kubectl

```bash
# Use the output from Terraform, or run:
aws eks update-kubeconfig --region us-east-1 --name weather-api-cluster

# Verify connection
kubectl get nodes
```

## Step 4 — Update Docker Image Reference

Edit `k8s/deployment.yaml` and replace `username/weather-api:latest` with your actual Docker Hub image:

```yaml
image: your-dockerhub-username/weather-api:latest
```

## Step 5 — Deploy the Application

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

## Step 6 — Get the Public URL

```bash
# Wait for the LoadBalancer to be provisioned (~2-3 minutes)
kubectl get svc weather-api

# The EXTERNAL-IP column shows the AWS LoadBalancer DNS name
# Example: k8s-weatherap-xxxxxxxxxx-xxxxxxxx.us-east-1.elb.amazonaws.com
```

## Step 7 — Access the API

Once the external DNS is available:

- **Swagger UI**: `http://<EXTERNAL-DNS>/swagger`
- **Weather Forecast**: `http://<EXTERNAL-DNS>/WeatherForecast`
- **Health Check**: `http://<EXTERNAL-DNS>/health`

## GitHub Actions CI/CD

The workflow (`.github/workflows/ci-cd.yml`) automatically builds and pushes the Docker image on every push to `main`.

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

## Local Development

```bash
cd src/WeatherApi
dotnet run
# API available at http://localhost:8080/swagger
```

## Local Docker Build

```bash
docker build -t weather-api .
docker run -p 8080:8080 weather-api
# API available at http://localhost:8080/swagger
```

## Cleanup

```bash
# Delete Kubernetes resources
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml

# Destroy AWS infrastructure
cd infra/terraform
terraform destroy
```
