# --- root/backends.tf --

terraform {
  backend "s3" {
    bucket = "migrationav"
    key    = "group-b/tf-state/terraform.tfstates"
    region = "us-east-1"
    dynamodb_table = "migavtable"
  }
}