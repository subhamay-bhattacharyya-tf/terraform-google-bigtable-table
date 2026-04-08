resource "google_bigtable_instance" "this" {
  name                = var.instance_name
  project             = var.project_id
  deletion_protection = false

  cluster {
    cluster_id   = "${var.instance_name}-cluster"
    zone         = var.zone
    num_nodes    = 1
    storage_type = "HDD"
  }
}

module "bigtable_table" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  bigtable_table_config = {
    base_name           = var.base_name
    instance_name       = google_bigtable_instance.this.name
    deletion_protection = "UNPROTECTED"
    split_keys          = ["customer-a", "customer-b", "customer-c"]
  }
}
