# `valve-ctl` (Valve Ctrl) 를 사용한 샘플 프로젝트 배포 및 구동

모든 설명 기준은 MacOS bash shell 기준

## `valve-ctl` 개발 환경 구축 목적

`valve-ctl`은 다음과 같은 기능을 제공합니다.

- 컨테이너 빌드, 배포 표준 템플릿 제공
- 사용자 정의 표준 템플릿 정의 및 사용 방법 제공
- 개발중인 애플리케이션 개인 테스트 방법 제공
- 사용자 CLI 정의 및 통합 방법 제공

다음 두 개의 command로 로컬 쿠버네티스 클러스터에 application을 세팅하고 구동할 수 있습니다.
- `~$ valve fetch`   
- `~$ valve on`

# 로컬 쿠버네티스 환경 구축

Docker, Kubernetes 및 tools 설치
**Docker 설치**
Docker for Mac : [Get Docker Desktop for Mac (Stable)](https://download.docker.com/mac/stable/Docker.dmg)

**Kubernetes 설치** 
Docker-Desktop -> Preference -> Kubernetes 활성화

**Homebrew 설치**

    ruby -e "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/master/install)]"

# Valve-Ctl 설치 및 로컬 인프라 초기화
## Install
```
curl -sL repo.opsnow.io/valve-ctl/install | bash
```
수행 화면
```
~$ curl -sL repo.opsnow.io/valve-ctl/install | bash
$ INPUT Version :
$ github Version : v2.0.66
# version: v2.0.66
~$ 
```
## Update
```
valve update
```
수행 화면
```
~$ valve update
$ INPUT Version : 
$ github Version : v2.0.66
# version: v2.0.66
# Install start...

+
~$
```
## Help
```
valve help
```
수행화면 
```
~$ valve help

================================================================================
            _                  _   _   ____
__   ____ _| |_   _____    ___| |_| | |___ \
\ \ / / _` | \ \ / / _ \  / __| __| |   __) |
 \ V / (_| | |\ V /  __/ | (__| |_| |  / __/
  \_/ \__,_|_| \_/ \___|  \___|\__|_| |_____|
================================================================================
Version : v2.0.66
Usage: valve {Command} params..

Commands:
V2:
    help                    현재 화면을 보여줍니다.

    [valve-ctl tool 관리]
    update                  valve 를 최신버전으로 업데이트 합니다.
    version                 valve 버전을 확인 합니다.
    config                  저장된 설정을 조회 합니다.
    toolbox                 Local Kubernetes 환경을 구성하기 위한 툴 설치 및 환경 구성을 합니다.

    [valve-ctl 개발자 도구]
    search                  프로젝트 배포에 필요한 템플릿 리스트를 조회합니다.
    fetch                   프로젝트 배포에 필요한 템플릿를 개발 소스에 세팅(설치)합니다.
    on                      프로젝트를 Local Kubernetes에 배포합니다.
    off                     배포한 프로젝트를 삭제합니다.

    chart                   외부 프로젝트의 차트 릴리즈 목록을 확인하고 stable 버전을 관리합니다.
    repo                    외부 프로젝트 템플릿 레파지토리를 등록합니다.

    get                     배포한 프로젝트에 대한 정보를 확인합니다.
    ssh                     배포한 리소스의 pod에 ssh접속을 합니다.
    top                     배포한 리소스의 CPU, Memory 사용량을 조회합니다.
    log                     배포한 리소스의 로그를 조회합니다.
...
```

## valve 이용할 툴 설치
`valve toolbox install -l && valve toolbox install -c`
```
~$ valve toolbox install -l

# CONFIG Set

# linux [apt]

# 2019-12-06 01:22:48
================================================================================

# update...
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:2 http://archive.ubuntu.com/ubuntu bionic InRelease                                           
Get:4 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
...
```

## valve 초기화
```
k8s 환경 인프라 구축
~$ valve toolbox install -c

# CONFIG Set

$ helm init --upgrade
...
```

## 샘플 프로젝트 실행하기
### 샘플 프로젝트  준비
html로 작성된 샘플 프로젝트를 github로부터 받습니다.
```
~$ git clone https://github.com/opsnow-tools/hands-on-web.git

~$ cd hands-on-web

hands-on-web$ tree
.
├── README.md
└── src
    ├── favicon.ico
    └── index.html

1 directory, 3 files

hands-on-web$ 
```

### `valve search` 를 사용하여 template 검색
`valve search` 명령어는 app을 배포하기 위해 필요한 템플릿 검색을 수행합니다.
```
~$ valve search
[Default Template List]
R-batch
java-mvn-lib
java-mvn-springboot
java-mvn-tomcat
js-npm-nginx
js-npm-nodejs
terraform
web-nginx

[Custom Template List]   ex) [Repo Name]/[Template Name]

Use this command 'valve fetch -h' and fetch your template
~$
```

### valve를 사용하여 k8s 기반 구동 파일 생성
`valve fetch` 명령어는 k8s 배포를  위한 관련 파일을 생성합니다
먼저 샘플 프로젝트에 존재하는 샘플 파일을 먼저 삭제 후 `valve fetch` 명령을 수행합니다
```
valve fetch --name web-nginx --group simple --service web

or

valve fetch -n web-nginx -g simple -s web
```

수행 화면
```
hands-on-web$ valve fetch -n web-nginx -g simple -s web

# valve-ctl version: v2.0.66

# Default template setting success

# Template: web-nginx

$ sed -i -e s|def SERVICE_GROUP = .*|def SERVICE_GROUP = simple| Jenkinsfile

$ sed -i -e s|def SERVICE_NAME = .*|def SERVICE_NAME = web| Jenkinsfile

$ sed -i -e s|def REPOSITORY_URL = .*|def REPOSITORY_URL = https://github.com/opsnow-tools/hands-on-web.git| Jenkinsfile

+ valve fetch success
hands-on-web$
```

`valve fetch` 를 통하여 새롭게 생성된 Dockerfile, Jenkinsfile, draft.toml, charts를 확인할 수 있습니다
### valve 사용하여 샘플 프로젝트를 k8s에 배포
`valve on` 명령어를 사용하여 k8s에 배포를 합니다
```
valve on
```

수행 화면
```
hands-on-web$ valve on

$ docker build -t docker-registry.127.0.0.1.nip.io:30500/simple-web:latest .
Sending build context to Docker daemon  15.36kB
Step 1/4 : FROM nginx:1.13-alpine
 ---> ebe2c7c61055
Step 2/4 : RUN apk add --no-cache bash curl
 ---> Using cache
 ---> 91b9349a5465
Step 3/4 : EXPOSE 80
 ---> Using cache
 ---> a20c486506f7
Step 4/4 : COPY src /usr/share/nginx/html
 ---> Using cache
 ---> 79749dfc2332
Successfully built 79749dfc2332
Successfully tagged docker-registry.127.0.0.1.nip.io:30500/simple-web:latest

$ docker push docker-registry.127.0.0.1.nip.io:30500/simple-web:latest
The push refers to repository [docker-registry.127.0.0.1.nip.io:30500/simple-web]
9390ec2ccf86: Pushed 
f6c78e6a8d4c: Pushed 
a79fe6dff072: Pushed 
87deea508850: Pushed 
90c4db1d5ef5: Pushed 
cd7100a72410: Pushed 
latest: digest: sha256:fe10dcac6d69dd9b8d8c5cf9891194b17160a3eb3c05f6c06559a7ab9da68b27 size: 1572

$ helm upgrade --install simple-web-development charts/simple-web --namespace development                         --devel                          --set fullnameOverride=simple-web                         --set namespace=development
Release "simple-web-development" does not exist. Installing it now.
NAME:   simple-web-development
LAST DEPLOYED: Mon Dec 30 06:03:24 2019
NAMESPACE: development
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME        READY  UP-TO-DATE  AVAILABLE  AGE
simple-web  0/1    1           0          0s

==> v1/Pod(related)
NAME                         READY  STATUS             RESTARTS  AGE
simple-web-85b98664dc-mv42g  0/1    ContainerCreating  0         0s

==> v1/Service
NAME        TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)  AGE
simple-web  ClusterIP  10.109.103.239  <none>       80/TCP   0s

==> v1beta1/Ingress
NAME        HOSTS                        ADDRESS  PORTS  AGE
simple-web  simple-web.127.0.0.1.nip.io  80       0s

==> v2beta1/HorizontalPodAutoscaler
NAME        REFERENCE              TARGETS                       MINPODS  MAXPODS  REPLICAS  AGE
simple-web  Deployment/simple-web  <unknown>/80%, <unknown>/80%  1        5        0         0s


NOTES:
1. Get the application URL by running these commands:


$ helm ls simple-web-development
NAME                  	REVISION	UPDATED                 	STATUS  	CHART            	APP VERSION	NAMESPACE  
simple-web-development	1       	Mon Dec 30 06:03:24 2019	DEPLOYED	simple-web-v0.0.0	v0.0.0     	development

$ kubectl get pod -n development | grep simple-web
simple-web-85b98664dc-mv42g   0/1     ContainerCreating   0          1s
simple-web-85b98664dc-mv42g   0/1     Running   0          3s

+ valve on success

hands-on-web$
```

### 배포 결과 확인
`valve get` 명령을 사용하여 k8s에 배포된 pod 목록을 조회한다 
```
valve get --help

valve get -a
valve get --all

valve get -p
```

수행 화면
```
hands-on-web$ valve get -a
$ helm ls --all
NAME                  	REVISION	UPDATED                 	STATUS  	CHART                     	APP VERSION	NAMESPACE  
docker-registry       	1       	Mon Dec 30 06:01:34 2019	DEPLOYED	docker-registry-1.7.0     	2.6.2      	kube-system
heapster              	1       	Mon Dec 30 06:01:54 2019	DEPLOYED	heapster-0.3.2            	1.5.2      	kube-system
kubernetes-dashboard  	1       	Mon Dec 30 06:01:40 2019	DEPLOYED	kubernetes-dashboard-1.4.0	1.10.1     	kube-system
metrics-server        	1       	Mon Dec 30 06:01:45 2019	DEPLOYED	metrics-server-2.5.1      	0.3.1      	kube-system
nginx-ingress         	1       	Mon Dec 30 06:01:28 2019	DEPLOYED	nginx-ingress-1.4.0       	0.23.0     	kube-system
simple-web-development	1       	Mon Dec 30 06:03:24 2019	DEPLOYED	simple-web-v0.0.0         	v0.0.0     	development

$ kubectl get all --all-namespaces
NAMESPACE     NAME                                                 READY   STATUS    RESTARTS   AGE
development   pod/simple-web-85b98664dc-mv42g                      1/1     Running   0          5m25s
kube-system   pod/coredns-86c58d9df4-5zgrw                         1/1     Running   2          5d21h
kube-system   pod/coredns-86c58d9df4-nfd89                         1/1     Running   2          5d21h
kube-system   pod/docker-registry-5979c99fc7-p7pn7                 1/1     Running   0          7m15s
kube-system   pod/etcd-minikube                                    1/1     Running   2          5d21h
kube-system   pod/heapster-heapster-69cb59b6c5-8xlxw               2/2     Running   0          6m48s
kube-system   pod/kube-addon-manager-minikube                      1/1     Running   2          5d21h
kube-system   pod/kube-apiserver-minikube                          1/1     Running   2          5d21h
kube-system   pod/kube-controller-manager-minikube                 1/1     Running   2          5d21h
kube-system   pod/kube-proxy-k24gk                                 1/1     Running   2          5d21h
kube-system   pod/kube-scheduler-minikube                          1/1     Running   2          5d21h
kube-system   pod/kubernetes-dashboard-7b68d4f78b-qf6qt            1/1     Running   0          7m9s
kube-system   pod/metrics-server-7cd8d47f6d-hrdwg                  1/1     Running   0          7m4s
kube-system   pod/nginx-ingress-controller-8445dcd6cf-l62lg        1/1     Running   0          7m20s
kube-system   pod/nginx-ingress-default-backend-56d99b86fb-b8v2m   1/1     Running   0          7m20s
kube-system   pod/storage-provisioner                              1/1     Running   3          5d21h
kube-system   pod/tiller-deploy-664d6bdc7b-z5pq9                   1/1     Running   0          7m37s

NAMESPACE     NAME                                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
default       service/kubernetes                      ClusterIP      10.96.0.1        <none>        443/TCP                      5d21h
development   service/simple-web                      ClusterIP      10.109.103.239   <none>        80/TCP                       5m25s
kube-system   service/docker-registry                 NodePort       10.109.17.210    <none>        5000:30500/TCP               7m15s
kube-system   service/heapster                        ClusterIP      10.100.103.43    <none>        8082/TCP                     6m55s
kube-system   service/kube-dns                        ClusterIP      10.96.0.10       <none>        53/UDP,53/TCP                5d21h
kube-system   service/kubernetes-dashboard            ClusterIP      10.111.240.31    <none>        9090/TCP                     7m9s
kube-system   service/metrics-server                  ClusterIP      10.105.5.55      <none>        443/TCP                      7m4s
kube-system   service/nginx-ingress-controller        LoadBalancer   10.96.120.134    <pending>     80:30766/TCP,443:31333/TCP   7m20s
kube-system   service/nginx-ingress-default-backend   ClusterIP      10.103.98.190    <none>        80/TCP                       7m20s
kube-system   service/tiller-deploy                   ClusterIP      10.98.202.159    <none>        44134/TCP                    7m37s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           <none>          5d21h

NAMESPACE     NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
development   deployment.apps/simple-web                      1/1     1            1           5m25s
kube-system   deployment.apps/coredns                         2/2     2            2           5d21h
kube-system   deployment.apps/docker-registry                 1/1     1            1           7m15s
kube-system   deployment.apps/heapster-heapster               1/1     1            1           6m55s
kube-system   deployment.apps/kubernetes-dashboard            1/1     1            1           7m9s
kube-system   deployment.apps/metrics-server                  1/1     1            1           7m4s
kube-system   deployment.apps/nginx-ingress-controller        1/1     1            1           7m20s
kube-system   deployment.apps/nginx-ingress-default-backend   1/1     1            1           7m20s
kube-system   deployment.apps/tiller-deploy                   1/1     1            1           7m37s

NAMESPACE     NAME                                                       DESIRED   CURRENT   READY   AGE
development   replicaset.apps/simple-web-85b98664dc                      1         1         1       5m25s
kube-system   replicaset.apps/coredns-86c58d9df4                         2         2         2       5d21h
kube-system   replicaset.apps/docker-registry-5979c99fc7                 1         1         1       7m15s
kube-system   replicaset.apps/heapster-heapster-69cb59b6c5               1         1         1       6m48s
kube-system   replicaset.apps/heapster-heapster-8659cd9d7                0         0         0       6m55s
kube-system   replicaset.apps/kubernetes-dashboard-7b68d4f78b            1         1         1       7m9s
kube-system   replicaset.apps/metrics-server-7cd8d47f6d                  1         1         1       7m4s
kube-system   replicaset.apps/nginx-ingress-controller-8445dcd6cf        1         1         1       7m20s
kube-system   replicaset.apps/nginx-ingress-default-backend-56d99b86fb   1         1         1       7m20s
kube-system   replicaset.apps/tiller-deploy-664d6bdc7b                   1         1         1       7m37s

NAMESPACE     NAME                                             REFERENCE               TARGETS          MINPODS   MAXPODS   REPLICAS   AGE
development   horizontalpodautoscaler.autoscaling/simple-web   Deployment/simple-web   1%/80%, 1%/80%   1         5         1          5m25s
```

### 샘플 프로젝트 구동 확인
`valve get -i` 를 통해 URL을 확인하여 구동 여부를 확인할 수 있습니다.
```
~$ valve get -i

$ kubectl get ing -n development
NAME         HOSTS                         ADDRESS   PORTS   AGE
simple-web   simple-web.127.0.0.1.nip.io             80      9m51s
```

### 샘플 프로젝트 삭제
```
valve get --helm

valve off --helm 
```

수행 화면
```
hands-on-web$ valve get --helm

$ helm ls --all | grep development
simple-web-development	1       	Mon Dec 30 06:03:24 2019	DEPLOYED	simple-web-v0.0.0         	v0.0.0     	development

$ kubectl get pod,svc,ing -n development
NAME                              READY   STATUS    RESTARTS   AGE
pod/simple-web-85b98664dc-mv42g   1/1     Running   0          10m

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/simple-web   ClusterIP   10.109.103.239   <none>        80/TCP    10m

NAME                            HOSTS                         ADDRESS   PORTS   AGE
ingress.extensions/simple-web   simple-web.127.0.0.1.nip.io             80      10m

hands-on-web$ valve off --helm simple-web-development
release "simple-web-development" deleted

+ 
```
샘플 프로젝트를 `valve get --helm` 수행하여 선택하고 삭제 한다


### valve로 원격 프로젝트 로컬에서 실행하기
valve-ctl은 local directory에 있는 helm chats와 dockfile을 이용하여 local k8s에 배포를 한다. 
이 때 로컬에 있는 helm chart가 아닌 원격에 있는 helm chart를 사용하여 로컬 k8s에 배포하는 기능을 제공한다

```
valve chart list
valve chart version -n
valve on -e
```

수행화면
```
외부 chart list 를 통해 chart를 검색

~$ valve chart list

$ helm repo update chartmuseum
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "stable" chart repository
...Successfully got an update from the "chartmuseum" chart repository
Update Complete. ⎈ Happy Helming!⎈ 

$ curl -s https://chartmuseum-devops.coruscant.opsnow.com/api/charts | jq -r 'keys[]'

# Enter spacebar & listing charts more
...
dcos-auto-provisioning
demo-chatbot
dr-alertnow-consumer
...
sample-vue
sample-web
...

+
```

```
검색한 chart 이름으로 version을 검색

~$ valve chart version -n sample-vue

$ helm repo update chartmuseum
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "stable" chart repository
...Successfully got an update from the "chartmuseum" chart repository
Update Complete. ⎈ Happy Helming!⎈ 

$ curl -s https://chartmuseum-devops.coruscant.opsnow.com/api/charts/sample-vue | jq -r '.[].version'

# Enter spacebar & listing charts more

v0.0.1-20191004-0857
```

```
검색한 chart 이름과 version을 이용하여 valve on

~$ valve on -e sample-vue:v0.0.1-20191004-0857

# sample-vue:v0.0.1-20191004-0857
sample-vue:v0.0.1-20191004-0857

# It will be used stable chart

$ helm install sample-vue-development chartmuseum/sample-vue --version v0.0.1-20191004-0857 --namespace development
Release "sample-vue-development" does not exist. Installing it now.
NAME:   sample-vue-development
LAST DEPLOYED: Fri Dec  6 01:45:00 2019
NAMESPACE: development
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME        READY  UP-TO-DATE  AVAILABLE  AGE
sample-vue  0/1    1           0          0s

==> v1/Pod(related)
NAME                         READY  STATUS             RESTARTS  AGE
sample-vue-5777f5d57f-4hdpw  0/1    ContainerCreating  0         0s

==> v1/Service
NAME        TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)  AGE
sample-vue  ClusterIP  10.105.202.213  <none>       80/TCP   0s

==> v1beta1/Ingress
NAME        HOSTS                     ADDRESS  PORTS  AGE
sample-vue  sample-vue.jj0.opsnow.io  80       0s

==> v2beta1/HorizontalPodAutoscaler
NAME        REFERENCE              TARGETS                       MINPODS  MAXPODS  REPLICAS  AGE
sample-vue  Deployment/sample-vue  <unknown>/80%, <unknown>/80%  1        5        0         0s


NOTES:
1. Get the application URL by running these commands:


$ helm ls sample-vue-development
NAME                  	REVISION	UPDATED                 	STATUS  	CHART                          	APP VERSION	NAMESPACE  
sample-vue-development	1       	Fri Dec  6 01:45:00 2019	DEPLOYED	sample-vue-v0.0.1-20191004-0857	v0.0.0     	development

$ kubectl get pod -n development | grep sample-vue
sample-vue-5777f5d57f-4hdpw   0/1     ContainerCreating   0          1s
sample-vue-5777f5d57f-4hdpw   0/1     ContainerCreating   0          4s
sample-vue-5777f5d57f-4hdpw   0/1     Running   0          6s

+ valve on success
```
