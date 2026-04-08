# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- Bigtable table using the `terraform-google-module-template` module (source: `github.com/subhamay-bhattacharyya-tf/terraform-google-module-template`)
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A map type variable must be created from the input variable and the table name must be in the following format:

```text
<project_code>-<base_name>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `dev`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `bigtable_table_config` | `object` | Yes | See attribute table below |

`bigtable_table_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length <= 30 |
| `instance_name` | `string` | Yes | — | Name of the Bigtable instance the table belongs to |
| `split_keys` | `list(string)` | No | `[]` | Pre-split keys for the table |
| `column_family` | `list(object)` | No | `[]` | List of column family objects, each with a `family` attribute |
| `deletion_protection` | `string` | No | `PROTECTED` | One of: `PROTECTED`, `UNPROTECTED` |
| `change_stream_retention` | `string` | No | `null` | Duration string for change stream retention (e.g., `24h0m0s`) |
| `automated_backup_policy` | `object` | No | `null` | Automated backup configuration with `retention_period` and `frequency` |

**outputs.tf:**

- Outputs for all standard Bigtable table attributes:
  - `table_id`
  - `table_name`
  - `table_project`
  - `table_instance_name`
  - `table_column_families`
  - `table_deletion_protection`

**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/bigtable_table_basic_test.go`: This Terratest tests the basic Bigtable table configuration.
- `test/bigtable_table_column_family_test.go`: This Terratest tests the Bigtable table with column family configuration.
- `test/bigtable_table_split_keys_test.go`: This Terratest tests the Bigtable table with pre-split keys configuration.
- `test/bigtable_table_change_stream_test.go`: This Terratest tests the Bigtable table with change stream retention configuration.
- `test/bigtable_table_backup_policy_test.go`: This Terratest tests the Bigtable table with automated backup policy configuration.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always links to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
