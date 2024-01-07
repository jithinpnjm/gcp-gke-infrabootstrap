// Base Cluster Configuration
resource "google_container_cluster" "base" {
  provider                    = google-beta
  project                     = var.project_id
  name                        = var.name
  location                    = var.cluster_location
  node_locations = length(var.node_locations) == 1 && var.cluster_location == var.node_locations[0] ? [] : var.node_locations
  default_max_pods_per_node   = var.default_max_pods_per_node
  remove_default_node_pool    = true
  initial_node_count          = length(var.node_locations)
  network                     = var.network
  subnetwork                  = var.subnetwork
  min_master_version          = var.gke_version
  release_channel {
    channel = var.gke_upgrade_channel
  }
  enable_binary_authorization = true
  enable_intranode_visibility = true
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  addons_config {
    http_load_balancing {
      disabled = ((var.addon_http_load_balancing) ? false : true)
    }

    gce_persistent_disk_csi_driver_config {
      enabled = var.addon_gce_persistent_disk_csi_driver_config
    }
    dns_cache_config {
      enabled = var.addon_dns_local_cache
    }
    config_connector_config {
      enabled = var.addon_config_connector_config
    }

  }
  lifecycle {
    ignore_changes = [
      node_config,
      resource_labels
    ]
  }
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true 
    master_ipv4_cidr_block  = var.master_private_cidr_block
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_cidr_range_name
    services_secondary_range_name = var.services_cidr_range_name
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_network_cidr
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }
network_policy {
    provider = "CALICO"
    enabled  = true
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  enable_legacy_abac = false
  enable_shielded_nodes = true
  enable_kubernetes_alpha = false
  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting
}

// Cluster Node Pools
resource "google_container_node_pool" "node_pools" {
  provider = google-beta
  project = var.project_id
  for_each = var.node_pool_attributes
  name = each.key
  cluster = google_container_cluster.base.name
  timeouts {
    create = "60m"
    update = "120m"
  }
  node_count = each.value["node_count"]
  version = each.value["version"]
  max_pods_per_node = each.value["max_pods"]
  location = var.cluster_location
  node_locations = length(each.value["nodepool_locations"]) == 0 ? var.node_locations : each.value["nodepool_locations"]
  autoscaling {
    max_node_count = each.value["auto_scaling_max_nodes"]
    min_node_count = each.value["auto_scaling_min_nodes"]
  }
  lifecycle {
       ignore_changes = [
        node_count
        ]
    }
 

  dynamic "network_config" {
    for_each = length(each.value["pod_secondary_range"]) == 0 ? [] : [1]
    content {
      create_pod_range = false
      pod_range = each.value["pod_secondary_range"]
      enable_private_nodes = each.value["enable_private_nodes"]
    }
  }

  node_config {
    disk_size_gb = each.value["disk_size_gb"]
    disk_type = each.value["disk_type"]

    image_type = each.value["node_image_type"]
    machine_type = each.value["machine_type"]
    service_account = var.serviceaccount
    //boot_disk_kms_key = var.kms_key_self_link != "" ? var.kms_key_self_link: null
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
    }
    dynamic "taint" {
      for_each = try(each.value["taints_configs"], null)
      content {
            key = (taint.value["taint_key"] != "" ? taint.value["taint_key"]: "")
            value = (taint.value["taint_value"] != "" ? taint.value["taint_value"]: "")
            effect = (taint.value["taint_effect"] != "" ? taint.value["taint_effect"]: "")
      }
    }
  }

  management {
    auto_repair = var.auto_repair_nodes
    auto_upgrade = var.auto_upgrade_nodes
  }

  upgrade_settings {
    max_surge = each.value["node_max_surge_on_upgrades"]
    max_unavailable = each.value["node_max_unavailable_on_upgrades"]
  }
}

# Add white listed container images artifactory
resource "google_binary_authorization_policy" "image_policy" {
  project = var.project_id

  dynamic "admission_whitelist_patterns"{
    for_each = (var.allowed_image_registries)
      content {
        name_pattern = admission_whitelist_patterns.value
      }
  }
  global_policy_evaluation_mode = "ENABLE"
  default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
  }
}

