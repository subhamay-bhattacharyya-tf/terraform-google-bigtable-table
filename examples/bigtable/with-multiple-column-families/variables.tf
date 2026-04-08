variable "environment" { type = string }
variable "project_code" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "base_name" { type = string }
variable "instance_name" { type = string }
variable "project_id" { type = string }
variable "zone" {
  type    = string
  default = "us-central1-a"
}
