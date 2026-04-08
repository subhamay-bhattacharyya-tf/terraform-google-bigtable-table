# ============================================================================
# Bigtable Table Module - Variables
# ============================================================================

variable "environment" {
  description = "Deployment environment (dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["devl", "test", "prod"], var.environment)
    error_message = "environment must be one of: devl, test, prod."
  }
}

variable "project_code" {
  description = "Short project identifier used in resource naming."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,19}$", var.project_code))
    error_message = "project_code must start with a lowercase letter, contain only lowercase alphanumeric characters or dashes, and be 2-20 characters long."
  }
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "bigtable_table_config" {
  description = "Configuration for the Bigtable table resource."
  type = object({
    base_name               = string
    instance_name           = string
    split_keys              = optional(list(string), [])
    column_family           = optional(list(object({ family = string })), [])
    deletion_protection     = optional(string, "PROTECTED")
    change_stream_retention = optional(string, null)
    automated_backup_policy = optional(object({
      retention_period = string
      frequency        = string
    }), null)
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,30}$", var.bigtable_table_config.base_name))
    error_message = "base_name must be alphanumeric or dashes and at most 30 characters."
  }

  validation {
    condition     = length(var.bigtable_table_config.instance_name) > 0
    error_message = "instance_name must not be empty."
  }

  validation {
    condition     = contains(["PROTECTED", "UNPROTECTED"], var.bigtable_table_config.deletion_protection)
    error_message = "deletion_protection must be one of: PROTECTED, UNPROTECTED."
  }

  validation {
    condition = alltrue([
      for cf in var.bigtable_table_config.column_family :
      length(cf.family) > 0
    ])
    error_message = "Each column_family must have a non-empty family name."
  }
}
