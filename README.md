# README

## Overview

This repository contains a Terraform-based infrastructure setup for deploying applications on Google Cloud Platform (GCP).

It includes:
- Cloud Run service deployment
- Global HTTPS Load Balancer
- Google Cloud DNS integration
- Artifact Registry
- Service Accounts & IAM bindings
- Cloud Build triggers

Everything is modular. Each folder represents a separate Terraform module responsible for a specific part of the infrastructure.

## Repository Structure
#### ```/modules```

Contains reusable Terraform modules:
- cloud_run – deploys a Cloud Run service
- artifact_registry – creates Docker/OCI repositories
- dns – creates DNS zones and records
- load_balancer – global HTTP(S) LB configuration
- iam – service accounts and IAM roles
- cloud_build – Cloud Build triggers


## How to Run
1. Clone the repository
```git clone https://github.com/Core5-team/iac_gcp_portal.git```
```cd iac_gcp_portal```

2. Install Google Cloud SDK

Follow the official instructions: https://docs.cloud.google.com/sdk/docs/install-sdk

After installation:
```gcloud init```
```gcloud auth login```
```gcloud auth application-default login```

3. Create a GCP Project

You can do this in the console, or via CLI:

```gcloud projects create <project-id>```
```gcloud config set project <project-id>```

4. Enable required APIs

These are the APIs needed for this infrastructure.
You can enable them manually in the GCP Console or via CLI.

Required APIs:
- analyticshub.googleapis.com
- artifactregistry.googleapis.com
- bigquery.googleapis.com
- bigqueryconnection.googleapis.com
- bigquerydatapolicy.googleapis.com
- bigquerydatatransfer.googleapis.com
- bigquerymigration.googleapis.com
- bigqueryreservation.googleapis.com
- bigquerystorage.googleapis.com
- cloudapis.googleapis.com
- cloudresourcemanager.googleapis.com
- cloudtrace.googleapis.com
- compute.googleapis.com
- containerregistry.googleapis.com
- dataform.googleapis.com
- dataplex.googleapis.com
- datastore.googleapis.com
- dns.googleapis.com
- iam.googleapis.com
- iamcredentials.googleapis.com
- logging.googleapis.com
- monitoring.googleapis.com
- oslogin.googleapis.com
- pubsub.googleapis.com
- run.googleapis.com
- servicemanagement.googleapis.com
- serviceusage.googleapis.com
- sql-component.googleapis.com
- storage-api.googleapis.com
- storage-component.googleapis.com
- storage.googleapis.com

**If terraform apply fails with an “API not enabled” error, open the link inside the error message and enable the missing API.**

5. Configure Cloud Build

  5.1 Go to Cloud Build → Repositories
  5.2 Add your git repository
  5.3 Authenticate when prompted

This repo must contain :
- ```cloudbuild.yaml```
- The application source code and Dockerfile

6. Configure terraform.tfvars

Inside your cloned repo in root, you must set the required variables:
```
project_id    = "<your-project-id>"
domain        = "<your-domain.xy.com>"
git_repo_name = "<git-repo-name>" # If you decide to use our repo, you should paste it:"Core5-team/portal_frontend"
git_branch    = "<git-repo-branch>" # If you decide to use our repo, you should paste it:"main"
```
**Important requirements:**

- Your domain must already exist and you must own it. GCP will create the DNS zone, but it does NOT register domains.
- After Terraform creates the DNS managed zone, you must update the NS records at your domain registrar
- Terraform will output 4 NS records (e.g., ns-cloud-d1.googledomains.com etc.).Copy them into your registrar’s DNS settings.

Only after NS records propagate, Cloud DNS and the Load Balancer will work correctly.

7. Deploy with Terraform

Inside of the root of repo:

```terraform init```
```terraform plan```
```terraform apply```

To destroy:

```terraform destroy```

### What this infrastructure does

When deployed, it creates:

- A Cloud Run service serving the application
- A global HTTPS load balancer routing traffic to Cloud Run
- DNS A/AAAA records pointing your domain to the load balancer
- Artifact Registry for container storage
- Service Accounts for Cloud Run, Cloud Build, Terraform
- Cloud Build pipeline for automatic deployments
- All necessary IAM permissions
- All required backend services (NEG, URL map, HTTPS proxy, certificates)

