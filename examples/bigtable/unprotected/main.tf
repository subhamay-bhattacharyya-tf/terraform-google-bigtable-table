module "bigtable_table" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  bigtable_table_config = {
    base_name           = var.base_name
    instance_name       = var.instance_name
    deletion_protection = "UNPROTECTED"
  }
}
