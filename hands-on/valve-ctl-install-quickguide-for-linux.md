# `valve-ctl` (Valve Ctrl) 를 설치 가이드

설치 가이드는 Linux 중 Ubuntu 18.04를 기준하며, 노트북이나 베어메탈에 설치되어 있는 것을 기준으로 합니다.

Cloud 환경(AWS, GCP, Azure, ...)의 VM은 가이드가 제대로 동작하지 않을 수 있습니다.

추후 CentOS 가이드 제공 예정.

## Linux 스펙

**Note:** 2020/01/02 스펙

OS 스펙 : 최소 2Core CPU / 최소 4G 메모리 / 최소 10G 여유공간

## Install Minikube
```
ubuntu@ubuntu:~# git clone https://github.com/longlg88/minikube_project

ubuntu@ubuntu:~# cd minikube_project

ubuntu@ubuntu:~/minikube_project# ./install.sh

ubuntu@ubuntu:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.13.5

ubuntu@ubuntu:~/.minikube_project# ./user_role.sh
```
> `uname -a` 검색 후 커널 버전이 Linux 5.x.x-generic 일 경우, 다음과 같이 명령어를 실행 바랍니다.
>
> `vagrant@ubuntu-bionic:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.15.2`

```
ubuntu@ubuntu:~/minikube_project# watch -n1 kubectl get pod -A
Every 1.0s: kubectl get pod -A                                                   ubuntu-bionic: Tue Dec 10 08:44:29 2019

NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-86c58d9df4-b2pbb           1/1     Running   0          107s
kube-system   coredns-86c58d9df4-mdjjd           1/1     Running   0          107s
kube-system   etcd-minikube                      1/1     Running   0          71s
kube-system   kube-addon-manager-minikube        1/1     Running   0          57s
kube-system   kube-apiserver-minikube            1/1     Running   0          52s
kube-system   kube-controller-manager-minikube   1/1     Running   0          49s
kube-system   kube-proxy-9tjpx                   1/1     Running   0          106s
kube-system   kube-scheduler-minikube            1/1     Running   0          70s
kube-system   storage-provisioner                1/1     Running   0          103s

ubuntu@ubuntu:~# sudo reboot


ubuntu@ubuntu:~# sudo minikube start --vm-driver=none --kubernetes-version v1.13.5
```
> `uname -a` 검색 후 커널 버전이 Linux 5.x.x-generic 일 경우, 다음과 같이 명령어를 실행 바랍니다.
>
> `vagrant@ubuntu-bionic:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.15.2`


# `valve-ctl` 설치 및 로컬 인프라 초기화
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