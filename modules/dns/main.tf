resource "google_compute_global_address" "lb_ip" {
  name         = var.lb_ip_name
  project      = var.project_id
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_dns_managed_zone" "zone" {
  name        = replace(var.domain, ".", "-")
  dns_name    = "${var.domain}."
  project     = var.project_id
  description = "Managed zone for ${var.domain}"
}
resource "google_dns_record_set" "root_a_record" {
  name         = "${var.domain}."
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.lb_ip.address]
}


resource "google_project_service" "dns_api" {
  project = var.project_id
  service = "dns.googleapis.com"
}

