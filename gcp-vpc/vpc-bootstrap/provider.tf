terraform {
  backend "gcs" {
    bucket  = "tf-state-allex-dev-vpc"
    prefix  = "terraform/state"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.60.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.60.0"
    }
  }
required_version = "~>1.6.6 "
}
provider "google" {

}

provider "google-beta" {

}
