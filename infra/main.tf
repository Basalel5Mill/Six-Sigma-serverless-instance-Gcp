locals {
  name_suffix = "1"
  openapi_cfg = file("api.yaml")
}

# A bucket for SPA static files
resource "google_storage_bucket" "static_bucket" {
  name          = "sixsigma-static-${random_id.bucket_suffix.hex}"
  project       = var.project_id
  storage_class = "standard"
  location      = "US"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "viewer" {
  bucket      = google_storage_bucket.static_bucket.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

resource "google_storage_bucket" "functions_bucket" {
  name          = "sixsigma-functions-${random_id.bucket_suffix.hex}"
  project       = var.project_id
  storage_class = "standard"
  location      = "US"
}

# Secret manager for API keys and configuration
resource "google_project_service" "secretmanager" {
  provider = google-beta
  service  = "secretmanager.googleapis.com"
}

# Placeholder for future analytics service configuration
resource "google_secret_manager_secret" "analytics_config" {
  provider = google-beta
  secret_id = "analytics-config"
  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_iam_binding" "analytics_config_secret_binding" {
  provider  = google-beta
  secret_id = google_secret_manager_secret.analytics_config.secret_id
  members = [
    "serviceAccount:${var.default_service_account}"
  ]
  role = "roles/secretmanager.secretAccessor"
}

# Analytics processing function
module "function_service_analytics" {
  source = "./modules/function"
  source_dir = "../Sigma-backend/service-analytics"
  bucket_name = google_storage_bucket.functions_bucket.name
  project_id = var.project_id
  project_number = var.project_number
  function_name = "service-analytics"
  function_description = "Six Sigma Analytics Processing"
}

# DMAIC workflow function
module "function_service_dmaic" {
  source = "./modules/function"
  source_dir = "../Sigma-backend/service-dmaic"
  bucket_name = google_storage_bucket.functions_bucket.name
  project_id = var.project_id
  project_number = var.project_number
  function_name = "service-dmaic"
  function_description = "Six Sigma DMAIC Workflow Management"
}


resource "google_project_service" "firestore" {
  provider = google-beta
  project  = var.project_id
  service  = "firestore.googleapis.com"
}

resource "google_firestore_database" "database" {
  provider                    = google-beta
  project                     = var.project_id
  name                        = "(default)"
  location_id                 = "nam5"
  type                        = "FIRESTORE_NATIVE"
  concurrency_mode            = "OPTIMISTIC"
  app_engine_integration_mode = "DISABLED"

  depends_on = [google_project_service.firestore]
}

resource "google_api_gateway_api" "api_cfg" {
  provider = google-beta
  api_id   = "api-gw-main"
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider      = google-beta
  api           = google_api_gateway_api.api_cfg.api_id
  api_config_id = "cfg-${substr(sha256(local.openapi_cfg), 0, 5)}-${local.name_suffix}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = (base64encode(templatefile("api.yaml", {
        function_service_analytics = module.function_service_analytics.function_uri
        function_service_dmaic     = module.function_service_dmaic.function_uri
        managed_service            = google_api_gateway_api.api_cfg.managed_service
        google_oauth_client_id     = var.google_oauth_client_id
      })))
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "api_gw" {
  provider     = google-beta
  api_config   = google_api_gateway_api_config.api_cfg.id
  gateway_id   = "sixsigma-api-gw"
  display_name = "Six Sigma Analytics API Gateway"
  labels = {
    environment = "dev"
    project     = "sixsigma"
  }
}

output "api_gateway_main" {
  value = google_api_gateway_api.api_cfg.managed_service
}
output "api_gateway" {
  value = google_api_gateway_gateway.api_gw.default_hostname
}
