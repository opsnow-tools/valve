# eks-security group
# variable

## Security Group
variable "sg_name" {
  description = "Name of the Security Group, e.g: node"
}
 
variable "sg_desc" {
  description = "Description of the Security Group"
}
 
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
 
variable "is_self" {
  description = "If true, the security group itself will be added as a source to this ingress rule."
  default     = false
}
 
variable "source_sg_ids" {
  description = "source security group ids"
  # type        = "tuple"
  default     = []
}
 
variable "source_sg_cidrs" {
  description = "source cidrs"
  # type        = "tuple"
  default     = []
}
 
terraform {
  required_version = ">= 0.12"
}
 
provider "aws" {
  region = "ap-northeast-2"
}
 
module "eks-sg-node" {
    source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/securitygroup-inline?ref=v0.0.1"
 
    sg_name = var.sg_name
    sg_desc = var.sg_desc
 
    region = var.region
    city   = var.city
    stage  = var.stage
    name   = var.name
    suffix = var.suffix
 
    vpc_id = var.vpc_id
 
    # tuple : list of {description, source_cidr, from, to, protocol, type}
    source_sg_cidrs = var.source_sg_cidrs
 
}
 
output "sg-node" {
    value = "node security group id : ${module.eks-sg-node.sg_id}"
}