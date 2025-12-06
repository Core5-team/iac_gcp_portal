output "lb_ip_address" {
  value = google_compute_global_address.lb_ip.address
}

output "lb_ip_name" {
  value = google_compute_global_address.lb_ip.name
}

output "dns_zone_name" {
  value = google_dns_managed_zone.zone.name
}

