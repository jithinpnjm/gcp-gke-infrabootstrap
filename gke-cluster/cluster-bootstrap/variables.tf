
# GKE Cluster Base configuration
variable "project_id" {
  description = "Project to create GKE cluster in"
  type        = string
}

variable "gke_version" {
  description = "GKE version to use"
  type        = string
}

variable "name" {
  description = "Name of GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "GCP Region name or Zone name to create GKE cluster in. Zone or Region name in this input determines a regional vs zonal cluster"
  type        = string
}

variable "node_locations" {
  description = "GCP Zone names to create the nodes in."
  type        = list
}

variable "gke_upgrade_channel" {
  description = "Release channel to upgrade cluster nodes"
  type        = string
  default = "STABLE"
}

variable "network" {
  description = "Network self link to create GKE cluster in"
  type        = string
}

variable "subnetwork" {
  description = "Subnet self link to create GKE cluster in"
  type        = string
}


variable "serviceaccount" {
  description = "Service account to attach to GKE cluster nodes"
  type        = string
}

variable "master_private_cidr_block" {
  description = "GKE master node CIDR range. Mask must be /28 or higher"
  type        = string
}

variable "pods_cidr_range_name" {
  description = "GKE pods ip alias name"
  type        = string
}

variable "services_cidr_range_name" {
  description = "GKE services ip alias name"
  type        = string
}

variable "master_authorized_network_cidr" {
  description = "GKE master authorized network CIDR"
  type = list(map(string))
  default = [
    {
      cidr_block = "0.0.0.0/0"
      display_name = "default"
    }
  ]
}

variable "default_max_pods_per_node" {
  description = "GKE default max pods allowed per node"
  type        = string
}
# GKE Node Pool variables
variable "node_pool_attributes" {
  description = "GKE node pool attributes"
  type        = map
  default     = {}
}

variable "auto_repair_nodes" {
  description = "Whether the nodes will be automatically repaired"
  default = false
}

variable "auto_upgrade_nodes" {
  description = "Whether the nodes will be automatically upgraded"
  default = false
}

variable "addon_http_load_balancing" {
  description = "GKE addon http-loadbalancing"
  type        = bool
  default     = false
}

variable "addon_gce_persistent_disk_csi_driver_config" {
  description = "Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver"
  type        = bool
  default     = false
}

// TODO: Default this to "true" - all NodePools will be recreted if dns local cache is not already enabled so enable this carefully after
// all clusters are enabled with this add on
variable "addon_dns_local_cache" {
  description = "Whether to enable DNSLocalCache as a DeamonSet on all nodes"
  type        = bool
  default     = false
}

variable "addon_config_connector_config" {
  description = "Whether to enable ConfigConnector"
  type        = bool
  default     = false
}

variable "allowed_image_registries" {
  description = "GKE allowed images registries"
  type        = list
  default     = []
}
// Beta feature, so keeping the default to false
variable "enable_l4_ilb_subsetting" {
  description = "Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver"
  type        = bool
  default     = false
}

