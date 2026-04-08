output "table_name" {
  description = "The name of the Bigtable table."
  value       = module.bigtable_table.table_name
}

output "table_instance_name" {
  description = "The Bigtable instance name."
  value       = module.bigtable_table.table_instance_name
}

output "table_deletion_protection" {
  description = "The deletion protection setting."
  value       = module.bigtable_table.table_deletion_protection
}
