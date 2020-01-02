# `valve-ctl` (Valve Ctrl) 를 설치 가이드

설치 가이드는 Windows 10 기준으로 합니다.

# Install Vagrant in Windows 10

**Note:** 2020/01/02 설치 버전 기준 및 스펙

Vagrant : 2.2.6 

VirtualBox : 6.0.14

OS 스펙 : 최소 2Core CPU / 최소 4G 메모리 / 최소 10G 여유공간

> VirtualBox 최신(6.0.14 이상) 버전은 vagrant 최신버전(2020.01.02 기준 2.2.6)이 설치되지 않습니다.

## Vagrant Download & Install
1. https://www.vagrantup.com/downloads.html 링크에서 Windows 64-bit 버전으로 다운로드

2. vagrant_0.0.0_x86_64.exe 파일을 실행
## VirtualBox Download & Install
1. https://www.virtualbox.org/wiki/Download_Old_Builds_6_0 접근

2. VirtualBox 6.0.14 다운로드 및 실행
## Powershell 실행
Windows10 에서 기본으로 제공하는 Powershell을 실행

> **Note:**  Powershell은 글자색이 잘 안보일 수 있어 다음 세팅을 하고 진행

**Powershell 글자색 업데이트**
- https://github.com/microsoft/terminal/releases/tag/1708.14008 클릭
- colortool.zip 다운로드
- 압축을 풀고 Powershell을 열어서 압축 푼 Directory로 접근
- `colortool.exe OneHalfDark` 실행

## Vagrant init
```
PS C:\Users\user> mkdir k8s-vagrant

PS C:\Users\user> cd k8s-vagrant

PS C:\Users\user\k8s-vagrant>

PS C:\Users\user\k8s-vagrant> vagrant init ubuntu/bionic64

PS C:\Users\user\k8s-vagrant> ls
    디렉터리: C:\Users\user\k8s-vagrant

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----     2019-12-10   오후 3:27                .vagrant
-a----     2019-12-10   오후 3:36          44598 ubuntu-bionic-18.04-cloudimg-console.log
-a----     2019-12-10   오후 3:35           3189 Vagrantfile

PS C:\Users\user\k8s-vagrant> notepad Vagrantfile
```
[notepad Vagrantfile 내용]

아래 내용을 복사하고 저장합니다.
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 4048
  end
end
```
```
PS C:\Users\user\k8s-vagrant> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/bionic64'...
```

## Install Minikube
```
PS C:\Users\user\k8s-vagrant> vagrant ssh

...
vagrant@ubuntu-bionic:~# git clone https://github.com/longlg88/minikube_project

vagrant@ubuntu-bionic:~# cd minikube_project

vagrant@ubuntu-bionic:~/minikube_project# ./install.sh

vagrant@ubuntu-bionic:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.13.5

vagrant@ubuntu-bionic:~/minikube_project# ./user_role.sh

vagrant@ubuntu-bionic:~/minikube_project# watch -n1 kubectl get pod -A

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


vagrant@ubuntu-bionic:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.13.5
```

> `uname -a` 검색 후 커널 버전이 Linux 5.x.x-generic 일 경우, 다음과 같이 명령어를 실행 바랍니다.
>
> `vagrant@ubuntu-bionic:~/minikube_project# sudo minikube start --vm-driver=none --kubernetes-version v1.15.2`

```
vagrant@ubuntu-bionic:~# sudo reboot
Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.

PS C:\Users\longl\k8s-vagrant> vagrant ssh

vagrant@ubuntu-bionic:~# sudo minikube start --vm-driver=none --kubernetes-version v1.13.5

```
> `uname -a` 검색 후 커널 버전이 Linux 5.x.x-generic 일 경우, `sudo minikube start --vm-driver=none --kubernetes-version v1.15.2` 실행`

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

## Port Forwarding 작업
웹을 띄우기 위한 port forwarding 작업해야 합니다.

1. port forwarding 작업할 port 찾는다.
```
$ kubectl get svc -nkube-system | grep nginx-ingress-controller
nginx-ingress-controller        LoadBalancer   10.107.235.221   <pending>     80:31940/TCP,443:32205/TCP   97s
```
> **Note:** 위 예제는 80:31940 / 443:32205 를 사용중입니다. 사용자의 환경에 맞는 포트 번호를 기억해둡니다.

2. 위 값을 VirtualBox 에서 세팅 합니다.

VitualBox 관리자 -->  Running 중인 Virtualbox 선택 --> 오른쪽 마우스 클릭 -->  설정 --> 네트워크 --> 고급 --> 포트 포워딩 --> 윈도우 방화벽 액세스 허용

| 이름 | 프로토콜 | 호스트 포트 | 게스트 포트 |
| ----- | ----- | ----- | ----- |
| HTTP-80 | TCP | 80 | 31940 |
| HTTP-443 | TCP | 443 | 32205 |
> **Note:** 위 예제는 80:31940 / 443:32205 를 사용중입니다. 사용자의 환경에 맞는 포트 번호를 기억해둡니다.