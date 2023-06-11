# --- networking/outputs.tf --

output "vpc_id" {
    value = aws_vpc.vpc_ue1_devqa.id
}