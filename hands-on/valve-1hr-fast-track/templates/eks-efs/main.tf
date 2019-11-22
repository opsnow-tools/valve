# variable
 
variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}
 
variable "city" {
  description = "City Name of the cluster, e.g: VIRGINIA"
}
 
variable "stage" {
  description = "Stage Name of the cluster, e.g: DEV"
}
 
variable "name" {
  description = "Name of the cluster, e.g: DEMO"
}
 
variable "suffix" {
  description = "Name of the cluster, e.g: EKS"
}
 
variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}
 
variable "subnet_ids" {
  description = "List of Subnet Ids"
  type        = "list"
  default     = []
}
 
variable "mount_target_sg" {
  description = "Security Group ID for mount target"
  type        = "list"
  default     = []
}
 
# efs
 
terraform {
#   backend "s3" {
#     region = "ap-northeast-2"
#     bucket = "seoul-sre-jj-state"
#     key    = "jjeks-efs.tfstate"
#   }
  required_version = ">= 0.12"
}
 
provider "aws" {
  region = "ap-northeast-2"
}
 
module "efs" {
    source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/efs?ref=v0.0.1"
 
    region = var.region
    city   = var.city
    stage  = var.stage
    name   = var.name
    suffix = var.suffix
 
    vpc_id = var.vpc_id
 
    subnet_ids = var.subnet_ids
 
    #### default node.${local.lower_name}
    # mount_target_sg = var.mount_target_sg
}
 
output "efs_id" {
    value = "\nterraform import module.efs.aws_efs_file_system.efs ${module.efs.efs_id}\n"
}
 
output "efs_mount_target_ids" {
    value = "\nterraform import 'module.efs.aws_efs_mount_target.efs[0]' ${join("\nterraform import 'module.efs.aws_efs_mount_target.efs[*]' ", module.efs.efs_mount_target_ids)}\n"
}