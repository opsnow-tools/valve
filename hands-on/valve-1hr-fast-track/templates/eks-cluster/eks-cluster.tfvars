region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
#VPC에서 설정한 name으로 넣는다
# name   = "DEMO"
suffix = "EKS"
 
#VPC 생성 이후 발행된 id를 넣는다
# vpc_id = "vpc-0e757d9b678afa4c4"

kubernetes_version = "1.14"
 
#VPC 생성 이후 발행된 private subnet ids를 넣는다 
# subnet_ids = [
#   "subnet-00da93c3341a280f1",
#   "subnet-0f1d4256ef87b628a",
#   "subnet-02dbdf041b9439000",
# ]

#VPC 생성 이 후 발행된 public subnet id를 넣는다
# public_subnet_ids = [
#   "subnet-05f38ce7bd19e6ce6",
#   "subnet-04f888390a884cb5a",
#   "subnet-034d6045d0d608159",
# ]
 
  instance_type = "m5.large"
 
  mixed_instances = ["m4.large", "r4.large", "r5.large"]
 
  volume_size = "64"
 
  min = "1"
  max = "10"
 
  on_demand_base = "0"
  on_demand_rate = "0"
 
  key_name = "SEOUL-SRE-K8S-EKS"
 
# 생성하는 유저 정보를 넣는다
#   map_users = [
#     {
#       user     = "user/jamje.kim"
#       username = "jamje.kim"
#       group    = "system:masters"
#     },
#   ]