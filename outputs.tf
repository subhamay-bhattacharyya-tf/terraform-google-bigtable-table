# ============================================================================
# Bigtable Table Module - Outputs
# ============================================================================

output "table_id" {
  description = "The ID of the Bigtable table."
  value       = google_bigtable_table.this.id
}

output "table_name" {
  description = "The name of the Bigtable table."
  value       = google_bigtable_table.this.name
}

output "table_project" {
  description = "The project in which the Bigtable table was created."
  value       = google_bigtable_table.this.project
}

output "table_instance_name" {
  description = "The name of the Bigtable instance the table belongs to."
  value       = google_bigtable_table.this.instance_name
}

output "table_column_families" {
  description = "The column families configured on the Bigtable table."
  value       = google_bigtable_table.this.column_family
}

output "table_deletion_protection" {
  description = "The deletion protection setting of the Bigtable table."
  value       = google_bigtable_table.this.deletion_protection
}
