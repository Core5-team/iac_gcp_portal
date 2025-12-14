variable "project_id" { type = string }
variable "region" { type = string }
variable "service_name" { type = string }
variable "image" { type = string }
variable "env_vars" {
  type    = map(string)
  default = {}
}
variable "allowed_invokers" {
  type    = list(string)
  default = ["allUsers"]
}
variable "run_sa_email" { type = string }
