# 빠르게 시작하는 맨땅에서 EKS 구동 후 CICD 구축 후 App 배포 및 실행

## 사전 준비 작업

소유중인 public domain
Amazon Linux 2 AMI 기반 EC2 Instance

### AWS CLI 설정

AWS accesses key를 설정한다

```bash
aws configure
```

### Valve

Valve를 사용하여 CICD 환경 구축에 필요한 각종 프로그램들을 간단하게 설치한다
설치되는 주요 목록은 valve-ctl에서 확인할 수 있다

```bash
curl -sL repo.opsnow.io/valve-ctl/install | bash
valve toolbox install -l
```

## Terraform 이용한 AWS 리소스 생성

사전 준비 작업 후 Terraform을 사용하여 AWS에 EKS 관련 리소스들을 생성해본다

### EKS 구축 환경 설정 후 구축

```bash
git clone 템플릿이 포함된 프로젝트를 다운받는다
cp configure.tfvars.template configure.tfvars
vi configure.tfvars
terraform init
terraform plan -var-file configure.tfvars
terraform apply -var-file configure.tfvars
```

## CICD Tools 설치

### valve-tools 이용하여 CICD Tools 설치

valve-tools을 사용하여 필요한 툴들을 설치합니다.

```bash
git clone https://github.com/opsnow-tools/valve-tools
cd valve-tools
./run.sh
```

툴 설치가 완료 된 후 아래를 순서대로 선택하여 설치를 진행한다

### 1) helm init

### 2) kube-ingress

### 2-a) nginx-ingress-nodeport

```bash
1. mydomain.io
Please select one. (1) : 1
Enter your ingress domain [seoul-sre-{name}-eks.mydomain.io] : {name}.mydomain.io
```

{name}  표시된 부분은 테라폼 설정파일에서 지정한 name 입니다.

### 3) kube-system

### 3-a) cluster-autoscaler

최신 버전과 안정화 버전을 선택할 수 있습니다.
앞으로 설치된 모든 버젼은 안정화된 버젼으로 설치하도록 합니다.

### 3-b) efs-provisioner

```bash
Input your file system id. [fs-cd4******] : 엔터
```

### 3-c) heapster

### 3-d) kube-state-metrics

### 3-e) metrics-server

### 4) monitoring

### 4-a) prometheus

```bash
Enter SLACK_TOKEN : 엔터
```

### 4-b) grafana

```bash
Enter PASSWORD [password] : 암호입력  
Enter G_CLIENT_ID : 엔터
Enter GRAFANA_LDAP : 엔터
```

### 5) devops

### 5-a) chartmuseum

### 5-b) docker-registry

### 5-c) jenkins

```bash
Enter PASSWORD [password] : 암호입력
```

### 5-d) sonarqube

### 5-e) sonatype-nexus

```bash
Enter PASSWORD [password] : 암호입력
```

### 6) save variables

### 7) Exit


## 설치된 프로그램 확인

설치된 프로그램으로 접근할 수 있는 도메인 목록을 확인한다

```bash
kubectl get ing -A
```

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
