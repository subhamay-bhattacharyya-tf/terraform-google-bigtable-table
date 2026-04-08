# ============================================================================
# Bigtable Table Module - Locals
# ============================================================================

locals {
  bigtable_table_config = merge(var.bigtable_table_config, {
    table_name = "${var.project_code}-${var.bigtable_table_config.base_name}-${var.environment}"
  })
}
