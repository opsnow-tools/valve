# 개발자를 위한 밸브 퀵 스타트

이 문서는 개발자 PC에 쿠버네티스 클러스터를 설치하는 방법을 소개하고 이후 `valve-ctl` 명령을 사용하여 개발 중인 프로젝트를 컨테이너 형태로 빠르게 배포하고 테스트해 보기 위한 목적으로 작성되었습니다.

* [쿠버네티스 클러스터 & `valve-ctl` 설치](##%20쿠버네티스%20클러스터%20&%20`valve-ctl`%20설치%20)
* [샘플 프로젝트 준비](##%20샘플%20프로젝트%20준비)
* [샘플 프로젝트 템플릿 적용](##%20샘플%20프로젝트%20템플릿%20적용)
* [샘플 프로젝트 실행](##%20샘플%20프로젝트%20실행)
* [원격 프로젝트 실행](##%20원격%20프로젝트%20실행)
* [샘플 프로젝트 실행 종료](##%20샘플%20프로젝트%20실행%20종료)

## 쿠버네티스 클러스터 & `valve-ctl` 설치
개발 환경에 맞게 쿠버네티스 클러스터를 준비하고 `valve-ctl`을 설치합니다.
* [Mac OS 설치 가이드](./valve-ctl-install-quickguide-for-mac.md)
* [Windows10 설치 가이드](./valve-ctl-install-quickguide-for-windows.md)
* [Linux(Ubuntu) 설치 가이드](./valve-ctl-install-quickguide-for-linux.md)

## 샘플 프로젝트 준비
샘플 프로젝트를 github로 부터 복제합니다.
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

## 샘플 프로젝트 템플릿 적용
`valve-ctl`은 프로젝트 유형별로 표준 템플릿을 제공합니다. 적당한 템플릿을 선택하기 위해서 `valve-ctl`이 제공하는 템플릿 목록을 확인할 필요가 있습니다.
이 때 사용할 수 있는 명령이 `valve search` 입니다.
```
hands-on-web$ valve search
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
```

샘플은 단순한 웹 페이지를 서비스하기 위한 프로젝트이기 때문에 `web-nginx` 템플릿을 적용할 수 있습니다.
템플릿 적용은 `valve fetch` 명령을 사용합니다.

```
hands-on-web$ valve fetch --name web-nginx --group simple --service web
```

위 명령을 수행하면 해당 프로젝트에 Dockerfile, Jenkinsfile, charts 디렉토리가 생성됩니다.

## 샘플 프로젝트 실행
`valve on` 명령을 사용하면 손쉽게 로컬 쿠버네티스 클러스터에 샘플 프로젝트를 배포할 수 있습니다.
```
hands-on-web$ valve on
```
> <주의> <br>일부 컴파일 단계가 필요한 프로젝트는 `valve on` 실행 전에 컴파일이 진행되어야 합니다. `valve on` 명령은 컴파일 단계 없이 바로 도커 이미지를 생성하고 이전 단계에서 생성된 helm 차트를 사용해 쿠버네티스 클러스터에 리소스를 생성합니다.

샘플 프로젝트가 쿠버네티스 클러스터에 컨테이너로 구동되었고 `valve get` 명령을 사용하여 k8s에 배포된 pod 목록을 조회할 수 있습니다.
```
hands-on-web$ valve get -a
```

`valve get -i` 명령을 사용하면 방금 배포한 서비스의 URL을 확인할 수 있습니다. 브라우져를 열고 http://simple-web.127.0.0.1.nip.io 를 URL 창에 입력하면 프로젝트의 홈 페이지가 열립니다.
```
hands-on-web$ valve get -i
hands-on-web$ kubectl get ing -n development
NAME         HOSTS                         ADDRESS   PORTS   AGE
simple-web   simple-web.127.0.0.1.nip.io             80      9m51s
```

## 원격 프로젝트 실행
개발 중인 프로젝트가 복수의 애플리케이션이 상호 작용하여 동작하고 더구나 해당 애플리케이션이 다른 사람, 다른 팀에 의해 개발되었다면 로컬 쿠버네티스 클러스터에 해당 서비스를 올리는 것은 비교적 번거로운 작업일 수 있습니다. 만약 여러팀이 원격에 도커 레지스트리와 chart 레지스트리를 공유하고 해당 애플리케이션이 레지스트리에 이미 도커 이미지로, helm 차트로 등록되어 있다면 `valve on -e` 명령을 사용해서 로컬 환경에 구동할 수 있습니다. 이러한 기능을 사용하여 개발자는 비교적 구성이 복잡한 MSA 아키텍처를 도입한 프로젝트의 로컬 테스트 환경을 갖출 수 있습니다.

```
~$ valve chart list
~$ valve chart version -n
~$ valve on -e
```


## 샘플 프로젝트 실행 종료
테스트를 완료하고 샘플 프로젝트를 로컬 쿠버네티스 클러스터에서 종료하고 싶을 때는 `valve get` 명령을 사용해서 삭제하려는 helm 목록을 확인하고 `valve off` 명령을 사용해서 해당 helm을 삭제해야 합니다.
```
hands-on-web$ valve get --helm
hands-on-web$ valve off --helm sample-web-development
```

## 더 보기
`valve-ctl` 프로젝트에 대한 좀 더 상세한 소개는 다음 문서를 참고하세요.
* [valve-ctl 프로젝트](https://github.com/opsnow-tools/valve-ctl)