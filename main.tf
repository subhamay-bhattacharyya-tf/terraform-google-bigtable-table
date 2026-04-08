# ============================================================================
# Bigtable Table Module - Main
# Creates and manages a Google Cloud Bigtable table.
# ============================================================================

resource "google_bigtable_table" "this" {
  name          = local.bigtable_table_config.table_name
  instance_name = local.bigtable_table_config.instance_name

  dynamic "column_family" {
    for_each = local.bigtable_table_config.column_family
    content {
      family = column_family.value.family
    }
  }

  split_keys              = length(local.bigtable_table_config.split_keys) > 0 ? local.bigtable_table_config.split_keys : null
  deletion_protection     = local.bigtable_table_config.deletion_protection
  change_stream_retention = local.bigtable_table_config.change_stream_retention

  dynamic "automated_backup_policy" {
    for_each = local.bigtable_table_config.automated_backup_policy != null ? [local.bigtable_table_config.automated_backup_policy] : []
    content {
      retention_period = automated_backup_policy.value.retention_period
      frequency        = automated_backup_policy.value.frequency
    }
  }
}
