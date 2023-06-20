# --- root/main.tf --

module "networking" {
  source   = "./networking"
  vpc_cidr = "10.0.0.0/16"
  public_sn_count = var.public_sn_count
  private_sn_count = var.private_sn_count
  max_subnets = var.max_subnets
  public_cidrs = var.public_cidrs
  private_cidrs = var.private_cidrs
}