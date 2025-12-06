resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "certmgr" {
  service = "certificatemanager.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "networking" {
  service = "servicenetworking.googleapis.com"
  project = var.project_id
}


resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "${var.service_name}-neg"
  project               = var.project_id
  region                = var.run_service_region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.run_service_name
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "${var.service_name}-backend"
  project               = var.project_id
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  enable_cdn            = false

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }

  connection_draining_timeout_sec = 0
}

resource "google_compute_url_map" "default" {
  name    = "${var.service_name}-urlmap"
  project = var.project_id

  default_service = google_compute_backend_service.default.self_link

  host_rule {
    hosts        = [var.domain]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.self_link
  }
}

resource "google_compute_managed_ssl_certificate" "managed_cert" {
  name    = var.certificate_map_name
  project = var.project_id

  managed {
    domains = [var.domain]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name    = "${var.service_name}-https-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default.self_link

  ssl_certificates = [google_compute_managed_ssl_certificate.managed_cert.self_link]

}
data "google_compute_global_address" "lb_ip" {
  name    = var.lb_ip_name
  project = var.project_id
  depends_on = [
    var.lb_ip_resource
  ]
}

resource "google_compute_global_forwarding_rule" "https_forwarding" {
  name                  = "${var.service_name}-fwd-https"
  project               = var.project_id
  ip_address            = data.google_compute_global_address.lb_ip.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy.self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.service_name}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding" {
  name                  = "${var.service_name}-fwd-http"
  project               = var.project_id
  ip_address            = data.google_compute_global_address.lb_ip.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
}



