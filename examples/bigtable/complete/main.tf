module "bigtable_table" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  bigtable_table_config = {
    base_name     = var.base_name
    instance_name = var.instance_name
    column_family = [
      { family = "cf1" },
      { family = "cf2" }
    ]
    split_keys              = ["row-a", "row-b", "row-c"]
    deletion_protection     = "UNPROTECTED"
    change_stream_retention = "48h0m0s"
    automated_backup_policy = {
      retention_period = "72h0m0s"
      frequency        = "24h0m0s"
    }
  }
}
