variable "project_id" { type = string }
variable "service_name" { type = string }
variable "domain" { type = string }
variable "lb_ip_name" { type = string }
variable "run_service_name" { type = string }
variable "run_service_region" { type = string }
variable "certificate_map_name" { type = string }

variable "lb_ip_resource" {
  type = any
}
