region = "ap-northeast-2"
city   = "SEOUL"
stage  = "SRE"
#VPC에서 설정한 name으로 넣는다
# name   = "DEMO"
suffix = "EKS"
 
#VPC 생성 이후 발행된 id를 넣는다
# vpc_id = "vpc-0e757d9b678afa4c4"
 
sg_name = "node"
sg_desc = "Security group for all worker nodes in the cluster"             
 
# tuple : list of {description, source_cidr, from, to, protocol, type}
source_sg_cidrs = [
    {
        desc = "Gangnam 13F 1, 2, wifi",
        cidrs = ["5.1.9.2/32", "5.1.9.9/32", "5.1.9.1/32"],
        from = 22,
        to = 22,
        protocol = "tcp",
        type = "ingress"
    },
]