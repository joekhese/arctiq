locals {
  labels = {
    name    = "joseph"
    mission = "training"
  }
  services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",

  ]
  roles = ["roles/servicemanagement.admin", "roles/storage.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/meshconfig.admin",
    "roles/compute.admin",
    "roles/container.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/gkehub.admin"
  ]
  billing_account     = "013283-34C035-A27D00"
  project_id          = "joe-training"
  project_name        = "joe-training"
  ip_cidr_range       = "10.121.0.0/20" // change to a smaller range
  secondary_range     = "10.121.128.0/21"
  secondary_range-two = "10.121.64.0/22"
  asm_version         = "1.9"

  public  = "10.121.0.0/18"
  managed = "10.121.64.0/18"
  private = "10.121.128.0/17"
  region  = "northamerica-northeast1"
  gke = {
    regional                 = true
    cluster_version          = "1.19.12-gke.2100"
    multi_az                 = true
    http_load_balancing      = true
    network_policy           = false
    remove_default_node_pool = true

    node_pool = {
      pools = [{
        name         = "my-node-pool"
        machine_type = "n1-standard-4"
        min_count    = 1
        max_count    = 2
      }]
      oauth_scopes = {
        all          = ["https://www.googleapis.com/auth/cloud-platform"]
        my-node-pool = []
      }
      labels = {
        all          = {}
        my-node-pool = {}
      }
      metadata = {
        all          = {}
        my-node-pool = {}
      }
      taints = {
        all          = []
        my-node-pool = []
      }
      tags = {
        all          = []
        my-node-pool = []
      }
    }
  }


}