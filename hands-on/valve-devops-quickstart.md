# 운영자를 위한 밸브 퀵 스타트

## 본 문서에서 구축할 아키텍쳐 구성도

Terraform을 사용하여 AWS에 VPC를 하나 생성 한 뒤 EKS와 EC2기반 Worker 인스턴스를 하나 생성합니다. 이 때  필요한 보안 그룹과 Storage, network를 생성하여 설정하여 줍니다.  

생성된 eks에 외부 연결을 위한 ingress를 설정하고 domain과 연결하여 줍니다.  
이 후 k8s를 감시할 수 있는 모니터링 툴(promethus, grafana)과 CD/CI툴(jenkins)에게 sub domain을 연결하여 접속할 수 있도록 설정하여 줍니다.  

## 사전 준비 작업

- Root domain
- Amazon Linux 2 AMI 기반 EC2 Instance
- Bastion에서 사용할 terraform 실행을 위한 Administrator Role
- EKS에서 사용할 worker node로 접속할 때 사용할 keypair

### AWS CLI 설정

AWS accesses key를 설정합니다.

```bash
aws configure
```

### Valve

Valve를 사용하여 CICD 환경 구축에 필요한 각종 프로그램들을 간단하게 설치합니다.  
설치되는 주요 목록은 valve-ctl에서 확인할 수 있습니다.

```bash
curl -sL repo.opsnow.io/valve-ctl/install | bash
valve toolbox install -l
```

## Terraform 이용한 AWS 리소스 생성

사전 준비 작업 후 Terraform을 사용하여 AWS에 EKS 관련 리소스들을 생성합니다.

### EKS 구축 환경 설정 후 구축

terraform을 사용하여 eks를 구축할 때 terranform.tfvars부분을 변경해야합니다.  
이 파일을 적절히 수정 후 terraform을 사용하여 eks를 구축합니다.

```bash
git clone https://github.com/opsnow-tools/valve-eks.git
cd valve-eks/example/eks-fast-track/
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
terraform init
terraform plan
terraform apply
cd
```

terraform으로 생성된 eks를 kubectl에 연결해야합니다. 이 내용은 terraform apply이 후 출력된 로그를 살펴보면 있습니다. 다음과 같은 형태입니다.

```bash
# kube config
aws eks update-kubeconfig --name {cluber name} --alias {cluber name}

# or
mkdir -p ~/.kube && cp .output/kube_config.yaml ~/.kube/config

```

둘 중 하나만 실행하면 됩니다.

## 운영 Tools 설치

### valve-tools 이용하여 CI/CD Tools 설치

valve-tools는 eks에 사용을 지원하는 툴(kube-ingress, kube-system)들과 모니터링 툴(monitoring) 그리고 CI/CD를 위한 툴(devops)들을 손쉽게 설치할 수 있도록 만든 공개 프로젝트입니다.  
valve-tools을 사용하여 필요한 툴들을 설치 할 것입니다.

```bash
git clone https://github.com/opsnow-tools/valve-tools
cd valve-tools
./run.sh
```

run.sh가 완료 된 후 아래를 순서대로 선택하여 설치를 진행합니다.

### 1) helm init

kubernetes(k8s)에 배포를 도와주는 툴

### 2) kube-ingress

### 2-a) nginx-ingress-nodeport

도메인으로 넘어온 트레픽을 k8s로 전달하는 nginx를 설치합니다.

```bash
1. {root domain}
Please select one. (1) : 1
Enter your ingress domain [seoul-sre-{name}-eks.{root domain}] : {name}.{root domain}
```

기본 도메인이 아닌 {name}.{root domain}형식의 도메인을 입력합니다.

### 3) kube-system

k8s 시스템 어플리케이션을 설치합니다.

### 3-a) cluster-autoscaler

cluster-node를 자동으로 늘려주는 툴 입니다.

### 3-b) efs-provisioner

container에 efs를 연결해주는 툴 입니다.  
file system id를 입력하는데, 기본 설정으로 설정하시면 됩니다.

```bash
Input your file system id. [fs-cd4******] :
```

### 3-c) kube-state-metrics

k8s의 상태를 metric화 하여 제공하는 툴입니다.

### 3-d) metrics-server

k8s의 상태 정보를 제공하는 툴입니다.

### 4) monitoring

모니터링 전문 툴을 설치합니다.

### 4-a) prometheus

다양한 metric들을 수집/제공하는 툴입니다.  
여기에선 k8s metrics정보를 수집합니다.  
설치 중 몇가지를 묻는 데 기본 값으로 설정하도록 합니다.

```bash
Enter SLACK_TOKEN : 엔터
```

### 4-b) grafana

각종 모니터링 데이터들을 시각화하여 보여주는 툴입니다.  
prometheus에서 데이터를 받아 시각화하여 웹 형식으로 제공합니다.

```bash
Enter PASSWORD [password] : 암호입력  
Enter G_CLIENT_ID : 엔터
Enter GRAFANA_LDAP : 엔터
```

### 5) devops

CI/CD 파이프라인 구성을 위한 툴 설치합니다.

### 5-a) chartmuseum

helm에서 사용할 chart를 제공합니다.

### 5-b) docker-registry

docker image를 괸라하는 툴입니다.

### 5-c) jenkins

ci/cd를 제공하는 툴입니다.

### 5-d) sonarqube

코드의 보안 품질 검사를 하는 툴입니다.

### 5-e) sonatype-nexus

java프로젝트에서 의존성 검사에 사용되는 repositogy 서버입니다.

### 6) save variables

툴 설치에 사용된 값들을 기록합니다.

### 7) Exit

valve-tools를 종료합니다.

## 설치된 프로그램들 확인

설치된 프로그램으로 접근할 수 있는 도메인 목록을 확인합니다.

```bash
kubectl get ing -A
```

### Monitoring tools 확인

k8s의 동작 상태를 모니터링 합니다.

#### Grafana 접속 및 확인

```web
Grafana 접속 URL : http://grafana-monitor.{name}.{public domain}   
로그인 아이디 : admin  
암호 : 설치 시 입력했던 암호(기본 암호 : password)  
``` 

이 후 dashboard에서 동작 확인 합니다.

### Devops tools 확인

#### Jenkins 접속 및 확인

```web
Jenkins 접속 URL : http://grafana-monitor.{name}.{public domain}  
로그인 아이디 : admin  
암호 : 설치 시 입력했던 암호(기본 암호 : password)  
```

#### Kubernetes 연결 설정

Jenkins -> Manage Jenkins -> Configure System -> Kubernetes URL에 443포트로 연결하도록 설정합니다  

```bash
https://kubernetes.default:443
```

### sample 프로젝트 배포

#### Multibranch Pipeline 생성

Branch Source > GitHub > Repository HTTPS URL 항목에서 [https://github.com/gelius7/sample-vue.git](https://github.com/gelius7/sample-vue.git) 등록합니다.  
생성한 task가 정상적으로 실행되는 지 로그를 확인합니다.  

#### 웹 Application 서비스 확인

젠킨스에서 배포가 정상적으로 이루어 지면 아래 명령어를 이용해 접속 도메인 정보 확인하고, 브라우저로 웹페이지에 접속해서 서비스가 정상인지 확인합니다.

```bash
kubectl get ing -A
```

웹 브라우저로 아래 URL에 접속하여 웹 페이지가 정상적으로 나오는지 확인합니다.

```bash
http://sample-vue-dev.{name}.{public domain}
```

## AWS 리소스 삭제

terraform으로 삭제합니다.

```bash
terraform destroy
```

---

Next. [Valve Ctl를 사용한 프로젝트 배포](valve-ctl-30min-quickstart.md)
