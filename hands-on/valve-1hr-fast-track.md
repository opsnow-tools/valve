# 1시간 Valve Fast Track

## 사전 준비 작업
### 로컬 PC에 쿠버네티스 설치되어 있어야 함 (kubectl 명령어 사용을 위해)
### valve-ctl 설치 [https://github.com/opsnow-tools/valve-ctl](https://github.com/opsnow-tools/valve-ctl)
```bash
$ git clone https://github.com/opsnow-tools/valve-ctl
$ cd valve-ctl
```
### valve-tools 설치 [https://github.com/opsnow-tools/valve-tools](https://github.com/opsnow-tools/valve-tools)
```bash
$ git clone https://github.com/opsnow-tools/valve-tools
$ cd valve-tools
```
### Terraform 설치
```bash
$ brew install tfenv
$ tfenv install 0.11.14
$ tfenv list
$ tfenv use 0.11.14
$ terraform version
```
### aws-iam-authenticator 설치
```bash
$ brew install aws-iam-authenticator
```
## Terraform 이용한 AWS 리소스 생성
### 로컬 PC 콘솔에서 AWS 접속 정보 설정
```bash
$ export AWS_ACCESS_KEY_ID=AKIA****************
$ export AWS_SECRET_ACCESS_KEY=I3dN***********************
```
### VPC 생성
```bash
$ mkdir vpc
$ cd vpc
$ vi main.tf
```
```
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
  name   = "DEMO"               # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함

  vpc_cidr = "10.101.0.0/16"    # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
   vpc_cidr = "10.101.0.0  public_subnet_enable = true
  public_subnet_count = 3
  public_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  public_subnet_cidrs = [
    "10.101.25.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
    "10.101.26.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
    "10.101.27.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
  ]
 
  private_subnet_enable = true
  private_subnet_count = 3
  private_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  private_subnet_cidrs = [
    "10.101.28.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
    "10.101.29.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
    "10.101.30.0/24",       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
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
```
```bash
$ terraform init
$ terraform plan
$ terraform apply    # 실행 결과를 별도의 텍스트파일에 저장해 둠
$ cd ..
```
### Security Group 생성
```bash
$ mkdir sg
$ cd sg
$ vi eks-security-group.tfvars
```
```
region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
name   = "DEMO"       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
suffix = "EKS"

# VPC 생성결과 정보를 보면 VPC ID 정보 있음
vpc_id = "vpc-0e7***************"
 
sg_name = "node"
sg_desc = "Security group for all worker nodes in the cluster"             
 
# tuple : list of {description, source_cidr, from, to, protocol, type}
source_sg_cidrs = [
        desc = "description... korea seoul...",
        # 로컬PC NAT IP를 설정한다. 복수개의 CIDR 등록 가능함.
        cidrs = ["***.***.***.***/32", "***.***.***.***/32", "***.***.***.***/32"],
        from = 22
        to = 22,
        protocol = "tcp",
        type = "ingress"
    },
]
```
```bash
$ vi main.tf
```
```
# 수정할 필요 없음
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
```
```bash
$ terraform init
$ terraform plan -var-file=eks-security-group.tfvars
$ terraform apply -var-file=eks-security-group.tfvars    # 실행 결과를 별도의 텍스트파일에 저장해 둠
$ cd ..
```
### EKS Cluster 생성
```bash
$ mkdir cluster
$ cd cluster
$ vi eks-cluster.tfvars
```
```
region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
name   = "DEMO"       # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
suffix = "EKS"

# VPC 생성결과 정보를 보면 VPC ID 정보 있음
vpc_id = "vpc-0e7**************"
 
kubernetes_version = "1.14"
 
subnet_ids = [
  "subnet-00da*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-0f1d*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-02db*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
]
public_subnet_ids = [
  "subnet-05f3*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-04f8*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-034d*************",   # Security Group 생성결과 정보를 보면 Subnet 정보 있음
]
 
 instance_type = "m5.large"
 mixed_instances = ["m4.large", "r4.large", "r5.large"]
 volume_size = "64"
 min = "1"
 max = "10"
 
 on_demand_base = "0"
 on_demand_rate = "0"
 
 key_name = "SEOUL-SRE-K8S-EKS"
 
  map_users = [
    {
      user     = "user/**********"    # AWS 계정 ID 입력
      username = "**********"         # AWS 계정 ID 입력
      group    = "system:masters"
    },
  ]
```
```bash
$ vi main.tf
```
```
# 수정할 필요 없음
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
```
```bash
$ terraform init
$ terraform plan -var-file=eks-cluster.tfvars
$ terraform apply -var-file=eks-cluster.tfvars      # 실행 결과를 별도의 텍스트파일에 저장해 둠
$ cd ..
```
실행 결과를 보면 다음과 같은 내용이 보입니다.
```
# kube config
aws eks update-kubeconfig --name seoul-sre-{name}****-eks --alias seoul-sre-{name}****-eks
```
로컬PC 콘솔에서 명령어를 실행합니다.
AWS EKS 리소스를 로컬PC kubectl 명령어를 이용해 조회하기 위한 설정입니다.
### Network 리소스 생성 (ALB, Route53, ACM)
```bash
$ mkdir network
$ cd network
$ vi eks-network.tfvars
```
```
root_domain = "opsnow.io"    # 도메인 설정은 미리 되어 있어야 함
 
region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
name   = "DEMO"             # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
suffix = "EKS"

vpc_id = "vpc-0e7****************"     # VPC 생성결과 정보를 보면 VPC ID 정보 있음
 
public_subnet_ids = [
  "subnet-05f3*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-04f8*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-034d*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
]
 
weighted_routing = 100
```
```bash
$ vi main.tf
```
```
# 수정할 필요 없음
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
}
 
output "record_set" {
    value = module.eks-domain.address
}
 
output "import_command-1" {
  value = module.eks-domain.import_command1
}
```
```bash
$ terraform init
$ terraform plan -var-file=eks-network.tfvars
$ terraform apply -var-file=eks-network.tfvars      # 실행 결과를 별도의 텍스트파일에 저장해 둠
$ cd ..
```
### EFS 생성
```bash
$ mkdir efs
$ cd efs
$ vi efs.tfvars
```
```
region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
name   = "DEMO"             # 여러명이 동시에 Hands On 진행할 경우 다르게 설정해야 함
suffix = "EKS"
 
vpc_id = "vpc-0e7***************"        # VPC 생성결과 정보를 보면 VPC ID 정보 있음
 
subnet_ids = [
  "subnet-00da*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-0f1d*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
  "subnet-02db*************",      # Security Group 생성결과 정보를 보면 Subnet 정보 있음
]
```
```bash
$ vi main.tf
```
```
# 수정할 필요 없음
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
}
 
output "efs_id" {
    value = "\nterraform import module.efs.aws_efs_file_system.efs ${module.efs.efs_id}\n"
}
 
output "efs_mount_target_ids" {
    value = "\nterraform import 'module.efs.aws_efs_mount_target.efs[0]' ${join("\nterraform import 'module.efs.aws_efs_mount_target.efs[*]' ", module.efs.efs_mount_target_ids)}\n"
}
```
```bash
$ terraform init
$ terraform plan -var-file=efs.tfvars
$ terraform apply -var-file=efs.tfvars      # 실행 결과를 별도의 텍스트파일에 저장해 둠
$ cd ..
```
## valve-tools 이용하여 툴 설치
valve-tools을 로컬PC에 설치합니다. (사전 준비 작업 참고)
```bash
$ git clone https://github.com/opsnow-tools/valve-tools.git
$ cd valve-tools
$ ./run.sh
```
화면에 보이는 번호를 선택하여 아래 툴들을 순서대로 설치합니다.
chartmuseum, docker-registry, jenkins 는 꼭 필요합니다.
### 1) helm init
### 2) nginx-ingress-nodeport
```bash
1. opsnow.io
Please select one. (1) : 1
Enter your ingress domain [seoul-sre-{name}-eks.opsnow.io] : {name}.opsnow.io
```
{name}  표시된 부분은 테라폼 설정파일에서 지정한 name 입니다.
### 3) cluster-autoscaler
버전은  최신  버전을  선택하면  안됩니다. 1번을 선택하여 설치합니다.
이후 설치하는 다른 툴 들도 동일하게 설치합니다.
### 4) efs-provisioner
```bash
Input your file system id. [fs-cd4******] : 엔터
```
### 5) heapster
### 6) kube-state-metrics
### 7) metrics-server
### 8) prometheus
```bash
Enter SLACK_TOKEN : 엔터
```
### 9) grafana
```bash
Enter PASSWORD [password] : 암호입력  
Enter G_CLIENT_ID : 엔터
Enter GRAFANA_LDAP : 엔터
```
### 10) chartmuseum
### 11) docker-registry
### 12) jenkins
```bash
Enter PASSWORD [password] : 암호입력
```
### 13) sonarqube
### 14) sonatype-nexus
```bash
Enter PASSWORD [password] : 암호입력
```
### 15) save variables
### 16) Exit
## 젠킨스에서 웹 Application 소스 배포
### 로컬 PC에서 아래 명령어로 젠킨스 도메인 정보 확인한다.
```bash
$ kubectl get ing -A
NAMESPACE NAME HOSTS ADDRESS PORTS AGE
devops chartmuseum chartmuseum-devops.andy.opsnow.io 80 23m
devops docker-registry docker-registry-devops.andy.opsnow.io 80 22m
devops jenkins jenkins-devops.andy.opsnow.io 80 21m
devops sonarqube-sonarqube sonarqube-devops.andy.opsnow.io 80 19m
devops sonatype-nexus sonatype-nexus-devops.andy.opsnow.io 80 18m
monitor grafana grafana-monitor.andy.opsnow.io 80 24m
```
예제 에서는 jenkins-devops.{name}.opsnow.io 확인.
### 젠킨스 접속
젠킨스 접속 URL : http://jenkins-devops.{name}.opsnow.io
로그인 아이디 : admin
암호 : 설치 시 입력했던 암호
### 젠킨스 환경 설정에서 "Kubernetes URL" 항목을 다음과 같이 수정한다. (443 추가)
https://kubernetes.default:443
### EKS 클러스트 롤 바인딩
valve-tools 설치된 폴더로 이동해서 다음 명령어 실행한다.
```bash
$ cd valve-tools/templates/jenkins
$ kubectl apply -f jenkins-rollbinding.yaml
clusterrolebinding.rbac.authorization.k8s.io/valve:jenkins created

$ kubectl get clusterrolebinding    # 롤 바인딩 정보 조회, valve:jenkins 정보 있는지 확인한다.
NAME AGE
admin:devops:default 58m
aws-node 6h14m
cluster-admin  6h14m
...
valve:jenkins  35s

$ kubectl get clusterrolebinding valve:jenkins -o yaml      # 상세 정보 조회
kind: ClusterRole
name: system:serviceaccount:devops:default
```
### Multibranch Pipeline 생성
Branch Source > GitHub > Repository HTTPS URL 항목에서
[https://github.com/gelius7/sample-vue.git](https://github.com/gelius7/sample-vue.git) 등록한다.
생성한 task가 정상적으로 실행되는 지 로그를 확인한다.
### 웹 Application 서비스 확인
젠킨스에서 배포가 정상적으로 이루어 지면 아래 명령어를 이용해 접속 도메인 정보 확인하고, 브라우저로 웹페이지에 접속해서 서비스가 정상인지 확인한다.
```bash
$ kubectl get ing -A
sample-dev sample-vue  sample-vue-dev.{name}.opsnow.io 80  55s
```
웹 브라우저로 아래 URL에 접속하여 웹 페이지가 정상적으로 나오는지 확인한다.
```
http://sample-vue-dev.{name}.opsnow.io
```
### 테라폼으로 생성한 자원을 삭제할 때는 생성한 역순으로 실행
vpc > sq > cluster > network > efs 순서로 리소스 생성했으므로...
efs > network > cluster > sq > vpc 순서로 리소스를 삭제한다.
main.tf 파일이 있는 폴더로 이동하여 terraform destroy 명령어를 실행한다.
리소스 생성시 .tfvars 파일을 사용했으면 삭제시에도 사용한다.
실행 명령 예) 
```
$ terraform destroy -var-file=efs.tfvars
```
