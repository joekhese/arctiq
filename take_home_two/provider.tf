provider "google" {
  version = "~>3.76.0"
}

terraform {
  backend "gcs" {
    bucket = "joe-arctiq-state"
    prefix = "joe/arctiq/gcp"
  }
}

# terraform {
#   backend "gcs" {
#     bucket = "arctiq-state-joe"
#     prefix = "joe/arctiq/gcp"
#   }
# }

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

