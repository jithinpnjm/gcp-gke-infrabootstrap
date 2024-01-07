project_id                          = "jithin-terraform-allex-test122"
vpc_name                            = "us-central1-allex-vpc-02"
vpc_auto_create_subnetworks         = false
vpc_delete_default_routes_on_create = false
vpc_routing_mode                    = "REGIONAL"
region                              = "us-central1"

subnet_attributes = {
  "us-central1-allex-vpc-2-sb-01" = {
    "subnet_region"                   = "us-central1",
    "subnet_cidr_range"               = "10.255.252.0/24",
    "secondary_subnet_range"          = []
  },
   "us-central1-allex-vpc-2-sb-02" = {
    "subnet_region"                   = "us-central1",
    "subnet_cidr_range"               = "10.255.251.0/24",
    "secondary_subnet_range" = []  
  },
"l7-us-central1-allex-vpc-2-proxy-only" = {
    "subnet_region"                   = "us-central1",
    "subnet_cidr_range"               = "192.168.128.0/24",
    "subnet_purpose"                  = "REGIONAL_MANAGED_PROXY",
    "subnet_role"                     = "ACTIVE",
    "secondary_subnet_range"          = []
  }
}

