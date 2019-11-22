# variable
 
variable "root_domain" {
  description = "Root domain address, e.g: opsnow.io"
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
 
variable "public_subnet_ids" {
  description = "List of Public Subnet Ids"
  type        = "list"
  default     = []
}
 
variable "worker_sg_id" {
  description = "EKS worker security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}
 
variable "weighted_routing" {
  description = "weighted_routing_policy aws_route53_record.address"
  default     = 100
}
 
terraform {
  required_version = ">= 0.12"
}
 
provider "aws" {
  region = "ap-northeast-2"
}
 
module "eks-domain" {
  source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/eks-network?ref=v0.0.1"
 
  root_domain = var.root_domain
 
  region = var.region
  city   = var.city
  stage  = var.stage
  name   = var.name
  suffix = var.suffix
 
  vpc_id = var.vpc_id
 
  public_subnet_ids = var.public_subnet_ids
 
  weighted_routing = var.weighted_routing
 
  # default node.${local.lower_name}
  # worker_sg_id = "sg-0c4c6b74de6721fa6"
 
}
 
output "record_set" {
    value = module.eks-domain.address
}
 
output "import_command-1" {
  value = module.eks-domain.import_command1
}