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
 
variable "kubernetes_version" {
  default = "1.12"
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
 
variable "launch_configuration_enable" {
  default = true
}
 
variable "associate_public_ip_address" {
  default = false
}
 
variable "instance_type" {
  default = "m4.large"
}
 
variable "mixed_instances" {
  type    = "list"
  default = []
}
 
variable "volume_type" {
  default = "gp2"
}
 
variable "volume_size" {
  default = "128"
}
 
variable "min" {
  default = "1"
}
 
variable "max" {
  default = "5"
}
 
variable "on_demand_base" {
  default = "1"
}
 
variable "on_demand_rate" {
  default = "30"
}
 
variable "key_name" {
  default = ""
}
 
variable "key_path" {
  default = ""
}
 
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = "list"
  default     = []
}
 
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"
  default     = []
}
 
variable "local_exec_interpreter" {
  description = "Command to run for local-exec resources. Must be a shell-style interpreter."
  type        = "list"
  default     = ["/bin/sh", "-c"]
}
 
variable "buckets" {
  type    = "list"
  default = []
}
 
variable "master_sg_id" {
  description = "EKS master security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}
 
variable "worker_sg_id" {
  description = "EKS worker security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}
 
variable "target_group_http_arn" {
  description = "Target group at ELB"
  type        = "string"
  default     = ""
}
 
variable "public_subnet_ids" {
  description = "List of Public Subnet Ids"
  type        = "list"
  default     = []
}
 
 
terraform {
  required_version = ">= 0.12"
}
 
provider "aws" {
  region = "ap-northeast-2"
}
 
module "eks-compute" {
  source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/eks-compute?ref=v0.0.1"
 
  region = var.region
  city   = var.city
  stage  = var.stage
  name   = var.name
  suffix = var.suffix
 
  kubernetes_version = var.kubernetes_version
 
  vpc_id = var.vpc_id
 
  subnet_ids = var.subnet_ids
 
  instance_type = var.instance_type
 
  mixed_instances = var.mixed_instances
 
  volume_size = var.volume_size
 
  min = var.min
  max = var.max
 
  on_demand_base = var.on_demand_base
  on_demand_rate = var.on_demand_rate
 
  key_name = var.key_name
 
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SEOUL-SRE-K8S-BASTION"
      username = "iam_role_bastion"
      group    = "system:masters"
    },
  ]
 
  map_users = var.map_users
 
}
 
data "aws_caller_identity" "current" {
}
 
output "config" {
    value = module.eks-compute.config
}