# `valve-ctl` (Valve Ctrl) 설치 가이드

설치 가이드는 MacOS bash shell 기준으로 합니다.

# Mac OS 내 로컬 쿠버네티스 환경 구축

Docker, Kubernetes 및 tools 설치
**Docker 설치**
Docker for Mac : [Get Docker Desktop for Mac (Stable)](https://download.docker.com/mac/stable/Docker.dmg)

**Kubernetes 설치** 
Docker-Desktop -> Preference -> Kubernetes 활성화

**Homebrew 설치**

    ruby -e "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/master/install)]"

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