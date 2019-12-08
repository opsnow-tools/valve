# Valve

Valve를 사용해 다음과 같은 일을 수행할 수 있습니다.
* 쿠버네티스 클러스터 구성(AWS EKS, kops, ...)
* DevOps 툴 체인 구성
* 젠킨스를 이용한 CI/CD 파이프라인
* 쿠버네티스 기반 애플리케이션 개발자 도구

## Projects
valve는 다음과 같은 프로젝트로 구성됩니다.

* 쿠버네티스 클러스터 생성
  * [valve-kops](https://github.com/opsnow-tools/valve-kops)
  * [valve-eks](https://github.com/opsnow-tools/valve-eks)
* DevOps 툴 체인 구성
  * [valve-tools](https://github.com/opsnow-tools/valve-tools)
* CI/CD 파이프라인
  * [valve-butler](https://github.com/opsnow-tools/valve-butler)
  * [valve-builder](https://github.com/opsnow-tools/valve-builder)
* 개발자 도구
  * [valve-ctl](https://github.com/opsnow-tools/valve-ctl)

## Hands-on guide to Valve
* [밸브를 통한 애플리케이션 배포 빠르게 시작하기](./hands-on/valve-ctl-30min-quickstart.md)
* [1시간 밸브 패스트트랙](./hands-on/valve-fast-track.md)