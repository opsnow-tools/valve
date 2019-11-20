# vpc

terraform {
  required_version = ">= 0.12"
}
 
provider "aws" {
  region = "ap-northeast-2"
}
 
module "vpc" {
  source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/vpc-pubsubnet-prisubnet?ref=v0.0.1"
 
  region = "ap-northeast-2"
  city   = "SEOUL"
  stage  = "SRE"
  #name은 가급적 알파벳과 숫자로만 구성한다(-,_등 사용 자제)
  name   = "DEMO"
 
  #vpc에서 사용할 cidr입력
  vpc_cidr = "1.1.0.0/16"
 
  #vpc에서 사용할 network를 설정한다 
  #public subnet과 private subnet을 필요로 한다
  #미리 할당해둔 cidr을 설정한다
  public_subnet_enable = true
  public_subnet_count = 3
  public_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  public_subnet_cidrs = [
    "1.1.25.0/24",
    "1.1.26.0/24",
    "1.1.27.0/24",
  ]
  
  private_subnet_enable = true
  private_subnet_count = 3
  private_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  private_subnet_cidrs = [
    "1.1.28.0/24",
    "1.1.29.0/24",
    "1.1.30.0/24",
  ]
 
  single_nat_gateway = true
 
  tags = {
    "kubernetes.io/cluster/seoul-sre-demo-eks"  = "shared"
  }
}
 
output "vpc_id" {
  value = module.vpc.vpc_id
}
 
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}
 
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
 
output "public_subnet_cidr" {
  value = module.vpc.public_subnet_cidr
}
 
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
 
output "private_subnet_cidr" {
  value = module.vpc.private_subnet_cidr
}
 
output "nat_ip" {
  value = module.vpc.nat_ip
}