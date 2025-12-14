variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Primary region for Cloud Run builds/artifact registry (for regional services)"
}

variable "location" {
  type        = string
  default     = "global"
  description = "Location for resources like Certificate Manager and Load Balancer where applicable"
}

variable "service_name" {
  type    = string
  default = "my-landing-app"
}

variable "domain" {
  type        = string
  description = "Primary domain you will attach to the load balancer (e.g. example.com)"
}

variable "git_repo_name" {
  type        = string
  description = "GitHub repo name in the form owner/repo (e.g. my-org/my-repo)"
}

variable "git_branch" {
  type    = string
  default = "main"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "allowed_invokers" {
  type        = list(string)
  default     = ["allAuthenticatedUsers"]
  description = "Who can invoke Cloud Run. For public set to ['allUsers'] or restrict to service accounts / identities."
}

