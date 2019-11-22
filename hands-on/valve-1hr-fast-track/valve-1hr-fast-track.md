# 사전 준비 작업

ubuntu 18.04.3 LTS

## tfenv 설치

```bash
sudo apt install unzip git
git clone https://github.com/kamatama41/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## terraform 설치

```bash
tfenv install 0.12.5
terraform version

실행 결과 >>>
Terraform v0.12.5
```

설치 후 버젼 확인한다

## Kubectl 설치

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
kubectl version

실행 결과 >>>
Client Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.3", GitCommit:"b3cbbae08ec52a7fc73d334838e18d17e8512749", GitTreeState:"clean", BuildDate:"2019-11-13T11:23:11Z", GoVersion:"go1.12.12", Compiler:"gc", Platform:"linux/amd64"}
```

설치 후 동작 확인 한다

### aws-cli 설치

```bash
sudo apt install awscli -y
```

## aws-iam-authenticator 설치

```bash
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/.local/bin && mv ./aws-iam-authenticator $HOME/.local/bin/aws-iam-authenticator && export PATH=$HOME/.local/bin:$PATH
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help
```

설치 후 동작 확인 한다

## valve-ctl 설치

```bash
git clone https://github.com/opsnow-tools/valve-ctl
cd valve-ctl
```

## valve-tools 설치

```bash
git clone https://github.com/opsnow-tools/valve-tools
cd valve-tools
```

# Terraform 이용한 AWS 리소스 생성

 사전 준비 작업 후 Terraform을 사용하여 AWS에 EKS 관련 리소스들을 생성해본다

## AWS 접속 정보 설정

```bash
export AWS_ACCESS_KEY_ID=AKIA****************
export AWS_SECRET_ACCESS_KEY=I3dN***********************
```

### VPC 설정 및 생성

#### VPC 설정

```bash
mkdir vpc
cd vpc
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/vpc/main.tf > main.tf
vi main.tf
```

다운로드 받은 main.tf 파일에서 필요한 부분들을 수정한다.
주의할 점은 **name은 가급적이면 알파벳과 숫자로** 이루어진 이름을 넣도록 한다.
여기서 정한 이름으로 이후 설치하는 프로그램들에서 지속적으로 사용한다. 이 때 프로그램마다 허용하는 특수 문자의 종류가 달라서 간혹 오류가 발생하므로 가능하면 특수문자는 넣지 않도록 한다.

#### VPC 생성

terraform apply 이 후 나오는 출력들(Outputs)을 계속해서 사용한다(private_subnet_ids, public_subnet_ids, vpc_id). 그러므로 메모를 해 두자.

```bash
terraform init
terraform plan
terraform apply    # 실행 결과를 저장해 둠
cd ..

실행 결과 >>>
...
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

nat_ip = [
  "1.1.6.6",
]
private_subnet_cidr = [
  "1.1.28.0/24",
  "1.1.29.0/24",
  "1.1.30.0/24",
]
private_subnet_ids = [
  "subnet-077ae66f6e1155dc1",
  "subnet-035291b46199b9a0e",
  "subnet-09e8f8368c7f7f810",
]
public_subnet_cidr = [
  "1.1.25.0/24",
  "1.1.26.0/24",
  "1.1.27.0/24",
]
public_subnet_ids = [
  "subnet-0f263d6e3ce73eae4",
  "subnet-0738abb8f54cf4187",
  "subnet-046f0e48632943029",
]
vpc_cidr = 1.1.0.0/16
vpc_id = vpc-0189e6768ccdd9c38


```

### Security Group 설정 및 생성

#### Security Group 설정

```bash
mkdir sg
cd sg
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/security-group/main.tf > main.tf
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/security-group/eks-security-group.tfvars > eks-security-group.tfvars
vi eks-security-group.tfvars
```

eks-security-group.tfvars 파일을 열어서 주석 부분을 적절히 수정한다. vpc_id와 같은 몇몇 변수는 vpc생성 이후 발행된 값을 사용한다

#### Security Group 생성

```bash
terraform init
terraform plan -var-file=eks-security-group.tfvars
terraform apply -var-file=eks-security-group.tfvars    # 실행 결과를 저장해 둠
cd ..

실행 결과 >>>
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

sg-node = node security group id : sg-00af59d49f16e0297
...
```

output으로 나온 값들을 저장해둔다

### EKS Cluster 설정 및 생성 이후 kubectl 연동

#### EKS Cluster 설정

```bash
mkdir cluster
cd cluster
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-cluster/main.tf > main.tf
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-cluster/eks-cluster.tfvars > eks-cluster.tfvars
vi eks-cluster.tfvars
```

eks-cluster.tfvars파일을 열어서 변수 설정을 해준다.

#### EKS Cluster 생성

```bash
terraform init
terraform plan -var-file=eks-cluster.tfvars
terraform apply -var-file=eks-cluster.tfvars      # 실행 결과를 저장해 둠

실행 결과 >>>
...
Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

config = #

# kube config
aws eks update-kubeconfig --name seoul-sre-lemydemo-eks --alias seoul-sre-lemydemo-eks

# or
mkdir -p ~/.kube && cp .output/kube_config.yaml ~/.kube/config

# files
cat .output/aws_auth.yaml
cat .output/kube_config.yaml

# get
kubectl get node -o wide
kubectl get all --all-namespaces
...
```

실행 결과를 보면 **kube config**하는 부분이 있다. aws 명령어를 사용하거나 mkdir~로 시작하는 명령을 수행하여 kube config를 수행하도록 한다
이 후 kubectl을 사용하여 config가 올바르게 되었는지 확인해본다

#### kubectl-EKS cluster 연동 및 동작 확인

```bash
mkdir -p ~/.kube && cp .output/kube_config.yaml ~/.kube/config
kubectl get node -o wide
cd ..

실행 결과 >>>

NAME                                             STATUS   ROLES    AGE     VERSION              INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                  CONTAINER-RUNTIME
ip-10-101-29-5.ap-northeast-2.compute.internal   Ready    <none>   3m39s   v1.14.6-eks-5047ed   1.1.29.5   <none>        Amazon Linux 2   4.14.138-114.102.amzn2.x86_64   docker://18.6.1

$ kubectl get all --all-namespaces
NAMESPACE     NAME                          READY   STATUS    RESTARTS   AGE
kube-system   pod/aws-node-mk9fk            1/1     Running   0          3m47s
kube-system   pod/coredns-dcc5cb8c4-82g6q   1/1     Running   0          7m5s
kube-system   pod/coredns-dcc5cb8c4-x6jxx   1/1     Running   0          7m5s
kube-system   pod/kube-proxy-5mtgw          1/1     Running   0          3m47s

NAMESPACE     NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes   ClusterIP   172.20.0.1    <none>        443/TCP         7m13s
kube-system   service/kube-dns     ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP   7m8s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   daemonset.apps/aws-node     1         1         1       1            1           <none>          7m8s
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           <none>          7m8s

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   2/2     2            2           7m8s

NAMESPACE     NAME                                DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-dcc5cb8c4   2         2         2       7m5s

```

### Network 리소스 설정 및 생성 (ALB, Route53, ACM)

#### Network 설정

```bash
mkdir network
cd network
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-network/main.tf > main.tf
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-network/eks-network.tfvars > eks-network.tfvars
vi eks-network.tfvars
```

eks-network.tfvars파일을 열어 변수 설정을 한다.

#### Network 생성

```bash
terraform init
terraform plan -var-file=eks-network.tfvars
terraform apply -var-file=eks-network.tfvars      # 실행 결과를 저장해 둠
cd ..

실행 결과 >>>

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

import_command-1 = 
terraform import -var-file=YOUR module.eks-domain.aws_route53_record.validation Z1PY2EID2YMYG4__8308f9c6b382b87dd5a3279e02f70b64.lemydemo.opsnow.io._CNAME

record_set = *.lemydemo.EXAMP.IO

```

생성 후 발행되는 record_set url로 ci/cd, monitoring tools등이 연결된다

### EFS 설정 및 생성

#### EFS 설정

```bash
mkdir efs
cd efs
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-efs/main.tf > main.tf
curl https://raw.githubusercontent.com/opsnow-tools/valve/master/hands-on/valve-1hr-fast-track/templates/eks-efs/eks-efs.tfvars > eks-efs.tfvars
vi eks-efs.tfvars
```

eks-efs.tfvars를 열어 변수들을 채워준다

#### EFS 생성

```bash
terraform init
terraform plan -var-file=efs.tfvars
terraform apply -var-file=efs.tfvars      # 실행 결과를 저장해 둠
cd ..
```

## AWS CLI와 연결 상태 확인

## valve-tools 이용하여 툴 설치

valve-tools을 사용하여 필요한 툴들을 설치합니다.

```bash
cd valve-tools
./run.sh
```

툴 설치가 완료 된 후 아래를 순서대로 선택하여 설치를 진행한다

### 1) helm init

### 2) kube-ingress

### 2-1) nginx-ingress-nodeport

```bash
1. EXAMP.IO
Please select one. (1) : 1
Enter your ingress domain [seoul-sre-{name}-eks.opsnow.io] : {name}.opsnow.io
```

{name}  표시된 부분은 테라폼 설정파일에서 지정한 name 입니다.

### 3) kube-system

### 3-1) cluster-autoscaler

최신 버전과 안정화 버전을 선택할 수 있습니다.
앞으로 설치된 모든 버젼은 안정화된 버젼으로 설치하도록 합니다.

### 3-2) efs-provisioner

```bash
Input your file system id. [fs-cd4******] : 엔터
```

### 3-3) heapster

### 3-4) kube-state-metrics

### 3-5) metrics-server

### 4) monitoring

### 4-1) prometheus

```bash
Enter SLACK_TOKEN : 엔터
```

### 4-2) grafana

```bash
Enter PASSWORD [password] : 암호입력  
Enter G_CLIENT_ID : 엔터
Enter GRAFANA_LDAP : 엔터
```

### 5) devops

### 5-1) chartmuseum

### 5-2) docker-registry

### 5-3) jenkins

```bash
Enter PASSWORD [password] : 암호입력
```

### 5-4) sonarqube

### 5-5) sonatype-nexus

```bash
Enter PASSWORD [password] : 암호입력
```

### 6) save variables

### 7) Exit

## 설치된 프로그램 확인

### Monitoring tools 확인

### Devops tools 확인

### EKS 삭제

테라폼으로 생성한 자원을 삭제할 때는 생성한 역순으로 실행한다

vpc --> sq --> cluster --> network --> efs 순서로 리소스 생성했으므로 역순으로 삭제를 한다
efs --> network --> cluster --> sq --> vpc 순서로 리소스를 삭제한다.

main.tf 파일이 있는 폴더로 이동하여 terraform destroy 명령어를 실행한다.
리소스 생성시 .tfvars 파일을 사용했으면 삭제시에도 사용한다.

```bash
terraform destroy -var-file=efs.tfvars
```

---

Next. Valve Ctl를 사용한 프로젝트 배포

---

이 아래 라인은 업데이트가 필요하다

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
