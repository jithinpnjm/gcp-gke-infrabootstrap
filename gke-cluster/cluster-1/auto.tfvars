project_id                     = "jithin-terraform-allex-test122"
gke_version                    = "1.25.12-gke.500"
name                           = "allex-gke-test-01"
cluster_location               = "us-central1"
node_locations                 = ["us-central1-a"]
network                        = "projects/jithin-terraform-allex-test122/global/networks/us-central1-allex-vpc-01"
subnetwork                     = "projects/jithin-terraform-allex-test122/regions/us-central1/subnetworks/us-central1-allex-vpc-1-sb-01"
master_private_cidr_block      = "192.168.33.0/28"
pods_cidr_range_name           = "us-central1-gke-pods-1"
services_cidr_range_name       = "us-central1-gke-svcs-1"
default_max_pods_per_node      = "16"
serviceaccount                 = "svc-gke-nodes-local-svc-accoun@jithin-terraform-allex-test122.iam.gserviceaccount.com"
auto_repair_nodes              = true
auto_upgrade_nodes             = false
gke_upgrade_channel            = "UNSPECIFIED"

// Add master authorization network
master_authorized_network_cidr = [
    {
        cidr_block   = "10.255.254.0/24"
        display_name = "subnet: us-central1-allex-vpc-1-sb-02"
    }
]


// GKE enable/disable addons & backup
addon_http_load_balancing                      = true
addon_gce_persistent_disk_csi_driver_config    = true

// List of container images registries allowed to deploy
allowed_image_registries      = [
"dockerhub.com/**",
"docker.com/**",
"quay.io/**",
"redis:7.0.11-alpine",
"ghcr.io/**",
"docker.io/**",
"docker.io/jithinpnjm/**"
    ]
# GKE Node Pool Attributes
node_pool_attributes = {
    "allex-generic-pool-1" = {
        node_count   = 1
        disk_size_gb = 100
        version = "1.25.12-gke.500"
        disk_type    = "pd-standard"
        machine_type = "n1-standard-2"
        max_pods     = 32
        auto_scaling_max_nodes = 1
        auto_scaling_min_nodes = 0
        node_max_surge_on_upgrades = 1
        node_max_unavailable_on_upgrades = 0
        taints_configs = []
        nodepool_locations = ["us-central1-f"]
        pod_secondary_range = ""
        node_image_type="cos_containerd"
  },  
}
