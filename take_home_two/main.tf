resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
  number  = false
}


resource "google_project" "joe-training" {
  name            = "${local.project_name}-${random_string.suffix.result}"
  project_id      = "${local.project_name}-${random_string.suffix.result}"
  billing_account = local.billing_account
  labels          = local.labels
}

# resource "google_project_service" "joe-training_services" {
#   for_each                   = toset(local.services)
#   project                    = google_project.joe-training.project_id
#   service                    = each.value
#   disable_dependent_services = true
#   disable_on_destroy         = true
#   timeouts {
#     create = "30m"
#     update = "30m"
#   }
# }



data "google_compute_zones" "available" {
  project = google_project.joe-training.name
  region  = local.region
}
data "google_client_config" "current" {}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = google_project.joe-training.project_id
  network_name = "${local.project_name}-network"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.project_name}-subnet"
      subnet_ip             = local.ip_cidr_range
      subnet_region         = local.region
      subnet_private_access = false
    }
  ]

  secondary_ranges = {
    "${local.project_name}-subnet" = [
      {
        range_name    = "${local.project_name}-sec-subnet"
        ip_cidr_range = local.secondary_range
      },
      {
        range_name    = "${local.project_name}-sec-subnet-two"
        ip_cidr_range = local.secondary_range-two
      }
    ]
  }
}


module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version = "v16.0.1"

  project_id               = google_project.joe-training.name
  name                     = google_project.joe-training.name
  region                   = local.region
  regional                 = local.gke.regional
  kubernetes_version       = local.gke.cluster_version
  zones                    = local.gke.multi_az == true ? data.google_compute_zones.available.names : list(data.google_compute_zones.available.names.0)
  network                  = module.vpc.network_name
  subnetwork               = module.vpc.subnets_names[0]
  ip_range_pods            = "${local.project_name}-sec-subnet"
  ip_range_services        = "${local.project_name}-sec-subnet-two"
  http_load_balancing      = local.gke.http_load_balancing
  network_policy           = local.gke.network_policy
  remove_default_node_pool = local.gke.remove_default_node_pool
  node_metadata            = "GKE_METADATA_SERVER"
  cluster_resource_labels  = local.labels
  node_pools               = local.gke.node_pool.pools

}

module "wordpress" {
  source  = "./mods/wordpress"
  enabled = true
}

module "consul" {
  source            = "./mods/consul"
  enabled           = true
  module_depends_on = [module.gke.endpoint]
}

resource "kubernetes_namespace" "webapp" {
  metadata {
    name = "web-app"
  }
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.1.1"

  project_id = google_project.joe-training.project_id

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
  ]
}


output "zones" {
  value = data.google_compute_zones.available.names
}

