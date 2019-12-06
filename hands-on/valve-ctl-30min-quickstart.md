# Valve-Ctrl를 사용한 샘플 프로젝트 배포 및 구동

모든 설명 기준은 MacOS bash shell 기준

# Coruscant 개발 환경 구축 목적

* 개발, 테스트, 운영 환경 통일화
* 배포 pipeline 자동화
* 비용절감, 배포속도향상, 클라우드 상호 이식성 등(+ Kubernetes 사용 경력)

# Docker, Kubernetes 및 tools 설치
**Docker 설치**
Docker for Mac : [Get Docker Desktop for Mac (Stable)](https://download.docker.com/mac/stable/Docker.dmg)

**Kubernetes 설치** 
Docker-Desktop -> Preference -> Kubernetes 활성화

**Homebrew 설치**

    ruby -e "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/master/install)]"

**nodejs 설치**

    brew install node

# Valve-Ctl 설치 및 로컬 인프라 초기화
## Install
```
curl -sL repo.opsnow.io/valve-ctl/install | bash
```
수행 화면
```
~$ curl -sL repo.opsnow.io/valve-ctl/install | bash
$ INPUT Version :
$ github Version : v2.0.54
# version: v2.0.54
~$ 
```
## Update
```
valve update
```
수행 화면
```
~$ valve update
# version: v2.0.54
$ INPUT Version :
$ github Version : v2.0.54
# version: v2.0.54

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
Version : v2.0.54
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
```
$ valve toolbox install -l

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
$ valve toolbox install -c
...
```

## 샘플 프로젝트 실행하기
### 샘플 프로젝트  준비
nodejs로 작성된 샘플 프로젝트를 github로부터 받은 후 관련 라이브러리를 설치합니다
```
git clone https://github.com/opsnow-tools/test-nodejs.git
cd test-nodejs
npm install
```
수행화면
```
$ git clone https://github.com/opsnow-tools/test-nodejs.git
Cloning into 'test-nodejs'...
remote: Enumerating objects: 109, done.
remote: Total 109 (delta 0), reused 0 (delta 0), pack-reused 109
Receiving objects: 100% (109/109), 26.82 KiB | 13.41 MiB/s, done.
Resolving deltas: 100% (44/44), done.
$ cd test-nodejs/
test-nodejs$ npm install
```
### valve를 사용하여 k8s 기반 구동 파일 생성
valve fetch명령어는 k8s 배포를  위한 관련 파일을 생성합니다
먼저 샘플 프로젝트에 존재하는 샘플 파일을 먼저 삭제 후 valve fetch명령을 수행합니다
```
rm -rf charts Dockerfile Jenkinsfile draft.toml
valve fetch --name js-npm-nodejs --group sample
```

수행 화면
```
test-nodejs$ rm Dockerfile Jenkinsfile draft.toml
test-nodejs$ rm -rf charts/
test-nodejs$ 
test-nodejs$ valve fetch --name js-npm-nodejs --group sample
/usr/local/share/valve-core/_template/fetch: line 121: [: -v: unary operator expected
# valve-ctl version: v2.0.32
$ sed -i -e s|def SERVICE_GROUP = .*|def SERVICE_GROUP = sample| Jenkinsfile

$ sed -i -e s|def SERVICE_NAME = .*|def SERVICE_NAME = nodejs| Jenkinsfile

$ sed -i -e s|def REPOSITORY_URL = .*|def REPOSITORY_URL = https://github.com/opsnow-tools/test-nodejs.git| Jenkinsfile

+ valve fetch success
test-nodejs$ 
```

valve fetch를 통하여 새롭게 생성된 Dockerfile, Jenkinsfile, draft.toml, charts를 확인할 수 있습니다
### valve 사용하여 샘플 프로젝트를 k8s에 배포
valve on 명령어를 사용하여 k8s에 배포를 합니다
```
valve on
```

수행 화면
```
test-nodejs$ valve on

$ docker build -t docker-registry.127.0.0.1.nip.io:30500/sample-nodejs:latest .
Sending build context to Docker daemon  6.739MB
Step 1/6 : FROM node:10-alpine
---> 0aa7bb41deca
Step 2/6 : RUN apk add --no-cache bash curl
---> Using cache
---> 8b9626886512
Step 3/6 : EXPOSE 3000
---> Using cache
---> ce39ae42af4c
Step 4/6 : WORKDIR /data
---> Using cache
---> 46eca71c889f
Step 5/6 : CMD ["npm", "run", "start"]
---> Using cache
---> f0426783f978
Step 6/6 : ADD . /data
---> cacf9fc83a4b
Successfully built cacf9fc83a4b
Successfully tagged docker-registry.127.0.0.1.nip.io:30500/sample-nodejs:latest

$ docker push docker-registry.127.0.0.1.nip.io:30500/sample-nodejs:latest
The push refers to repository [docker-registry.127.0.0.1.nip.io:30500/sample-nodejs]
1ba506e91bfa: Pushed
6d7324921476: Layer already exists
426823113004: Layer already exists
5cd6e0dd086a: Layer already exists
e44790980479: Layer already exists
9392007c1686: Layer already exists
f1b5933fe4b5: Layer already exists
latest: digest: sha256:8179ec458c3f876dad3cb9792fd28d333d5d77d1a931bdbd15f4b13cbf603a85 size: 1786

$ helm upgrade --install sample-nodejs-development charts/sample-nodejs --namespace development --devel  --set fullnameOverride=sample-nodejs --set namespace=development
Release "sample-nodejs-development" does not exist. Installing it now.
NAME: sample-nodejs-development
LAST DEPLOYED: Thu Nov 14 15:31:57 2019
NAMESPACE: development
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME READY  UP-TO-DATE  AVAILABLE  AGE
sample-nodejs  0/1  1 0  0s

==> v1/Pod(related)
NAME  READY  STATUS RESTARTS  AGE
sample-nodejs-7cd6b798b6-4hcdm  0/1  ContainerCreating  0 0s

==> v1/Service
NAME TYPE CLUSTER-IP EXTERNAL-IP  PORT(S)  AGE
sample-nodejs  ClusterIP  10.96.143.222  <none> 80/TCP 0s
 
==> v1beta1/Ingress
NAME HOSTS ADDRESS  PORTS  AGE
sample-nodejs  sample-nodejs.127.0.0.1.nip.io  80 0s

==> v2beta1/HorizontalPodAutoscaler
NAME REFERENCE TARGETS MINPODS  MAXPODS  REPLICAS  AGE
sample-nodejs  Deployment/sample-nodejs  <unknown>/80%, <unknown>/80%  1  5  0 0s

NOTES:
1. Get the application URL by running these commands:

$ helm ls sample-nodejs-development
NAME REVISION  UPDATED STATUS  CHART APP VERSION  NAMESPACE
sample-nodejs-development  1 Thu Nov 14 15:31:57 2019  DEPLOYED  sample-nodejs-v0.0.0  v0.0.0 development


$ kubectl get pod -n development | grep sample-nodejs
sample-nodejs-7cd6b798b6-4hcdm 0/1 ContainerCreating 0  1s
sample-nodejs-7cd6b798b6-4hcdm 0/1 Running 0  3s
 
+ valve on success
test-nodejs$ 
```

### 배포 결과 확인
valve ls 명령을 사용하여 k8s에 배포된 pod 목록을 조회한다 
```
valve get -a
valve get --all
```

수행 화면
```
test-nodejs$ valve get -a

$ helm ls --all | grep development
NAME REVISION  UPDATED STATUS  CHART APP VERSION  NAMESPACE
sample-nodejs-development  1 Thu Nov 14 15:31:57 2019  DEPLOYED  sample-nodejs-v0.0.0  v0.0.0 development

$ kubectl get pod,svc,ing -n development
NAME READY STATUS  RESTARTS AGE
pod/sample-nodejs-7cd6b798b6-4hcdm 1/1 Running 0  7m20s

NAME  TYPE  CLUSTER-IP  EXTERNAL-IP PORT(S) AGE
service/sample-nodejs ClusterIP 10.96.143.222 <none>  80/TCP  7m20s
 
NAME HOSTS  ADDRESS PORTS AGE
ingress.extensions/sample-nodejs sample-nodejs.127.0.0.1.nip.io 80  7m20s

+
```
"$ kubectl get pod,svc,ing -n development" 부분에 표시된 수행되는 pod이 1개 일 경우 정상 구동이다
sample-nodejs.127.0.0.1.nip.io에 접속하여 화면을 확인한다

### 샘플 프로젝트 삭제
```
valve off --helm 
```

수행 화면
```
test-nodejs$ valve off --helm sample-nodejs-development
  
```
샘플 프로젝트를 선택하여 삭제 한다


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

~$ value on -e sample-vue:v0.0.1-20191004-0857

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
