locals {
  labels = {
    name    = "joseph"
    mission = "training"
  }
  services = [
    # "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    # "containerregistry.googleapis.com",
    # "deploymentmanager.googleapis.com",
    # "iamcredentials.googleapis.com",
    # "iam.googleapis.com",
    # "oslogin.googleapis.com",
    # "pubsub.googleapis.com",
    # "replicapool.googleapis.com",
    # "replicapoolupdater.googleapis.com",
    # "resourceviews.googleapis.com",
    # "servicenetworking.googleapis.com",
    # "sqladmin.googleapis.com",
    # "storage-api.googleapis.com",
    # "storage-component.googleapis.com",
  ]
  billing_account     = "013645-1B15BB-BAD8A2"
  project_id          = "joe-training"
  project_name        = "joe-training"
  ip_cidr_range       = "10.121.0.0/20" // change to a smaller range
  secondary_range     = "10.121.128.0/21"
  secondary_range-two = "10.121.64.0/22"


  public  = "10.121.0.0/18"
  managed = "10.121.64.0/18"
  private = "10.121.128.0/17"
  region  = "northamerica-northeast1"
  gke = {
    regional                 = true
    cluster_version          = "1.19.12-gke.2100"
    multi_az                 = true
    http_load_balancing      = true
    network_policy           = true
    remove_default_node_pool = true

    default_node_pool = {
      pools = [{
        name         = "default-node-pool"
        machine_type = "n1-standard-1"
        min_count    = 1
        max_count    = 2
      }]
      oauth_scopes = {
        all               = ["https://www.googleapis.com/auth/cloud-platform"]
        default-node-pool = []
      }
      labels = {
        all               = {}
        default-node-pool = {}
      }
      metadata = {
        all               = {}
        default-node-pool = {}
      }
      taints = {
        all               = []
        default-node-pool = []
      }
      tags = {
        all               = []
        default-node-pool = []
      }
    }
  }


}