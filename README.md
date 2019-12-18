# Valve

## Valve 란?
밸브는 [BespinGlobal](https://www.bespinglobal.com/)의 Cloud Managment Platform(CMP) 서비스인 [OpsNow](https://www.opsnow.com/)의 개발/운영 환경을 자동화하는 과정에서 만들어진 코드 산출물입니다. 현재는 AWS EKS를 중심으로 인프라를 구축, 애플리케이션 배포를 위한 툴체인 구성 그리고 컨테이너로 애플리케이션을 배포하기 위한 코드를 가지고 있습니다.

현재 밸브는 다음과 같은 요구 사항을 수용하고 있습니다.

* 서비스 VM을 컨테이너로 이관
* 쿠버네티스 기반 서비스 개발 및 운영 지원
* 오픈소스 DevOps 툴 체인 통합 구성 및 연계 지원(Jenkins, Nexus, Sonaqube, Prometheus 외 다수)
* 댜양한 유형의 애플리케이션을 배포하기 위한 유연한 CI/CD 파이프라인 제공
* 인프라를 코드로 구성하는 IaC(Infrastructure as Code) 개념 지원
* GitOps 방법론에 기반

## Valve 프로젝트의 목표
밸브는 클라우드 기반 애플리케이션을 개발 및 운영하려는 DevOps팀 또는 SRE팀이 요구하는 인프라, 애플리이케이션 CI/CD 파이프라인, 애플리케이션 설정, 인증/인가, 모니터링, 알람, 로깅 등의 공통 기능을 손쉽게 구축 가능한 자동화 도구 및 방법론을 제공하는 것을 목표로 합니다.

이러한 목표로 보면 밸브가 일반적인 DevOps 표준 플랫폼 자체를 추구하는 것처럼 생각될 수 있습니다.
밸브는 일반적인 DevOps 플랫폼이나 표준 DevOps 플랫폼을 지향하지 않습니다. 오히려 DevOps팀이 원하는 표준 DevOps 플랫폼을 구축하는데 필요한 자동화 도구와 템플릿을 제공하여 빠르게 그들만의 최적화 된 DevOps 플랫폼을 구축할 수 있도록 돕는 것을 목표로 합니다. 일종의 맞춤형 DevOps 플랫폼 구성 도구에 가깝다고 할 수 있습니다.

DevOps 팀은 각기 다른 요구사항을 가지고 있습니다. 예를 들어 최종적으로 배포해야 할 클라우드 프로바이더가 다릅니다. 서비스를 구동해야하는 인프라가 VM, 컨테이너 또는 서버리스가 될 수 있습니다. 또한 원하는 DevOps 툴 체인도 다릅니다. 표준화된 DevOps 플랫폼이 이들 요구사항을 유연하게 모두 수용할 수 있을까요? 실제로는 어렵습니다.
표준화된 DevOps 플랫폼은 DevOps 팀의 모든 요구사항을 만족시킬 수 없습니다. DevOps 팀은 필요로하는 DevOps 툴체인 및 방법론을 개발하고 발전시킬 수 있어야 합니다. 여기에 밸브가 제공하는 자동화 도구 및 방법론을 활용하여 DevOps팀은 좀 더 신속하게 원하는 목적을 달성할 수 있습니다.

맞춤형 DevOps 플랫폼 구성 도구로 밸브가 가진 확장성을 예로 들면 다음과 같습니다.
밸브는 현재 AWS EKS를 지원하지만 향후에는 다른 CSP가 제공하는 GKE, AKS 도 지원할 수 있는 설계와 목표를 가지고 있습니다.
파이프라인을 대상으로 확장 가능합니다.
예를 들어, 최근에 밸브는 AWS Batch(AWS ECS 기반)에 R로 작성된 컨테이너를 배포할 수 있는 파이프라인 개발에 적용되었습니다.
다른 예로, 테라폼 코드를 작성하고 파이프라인을 통해 AWS 환경에 직접 인프라를 배포할 수 있도록 구현한 사례도 있습니다.

밸브가 모든 환경을 위한 DevOps 플랫폼 구성 도구가 되는 것을 목표로 하지 않으로 너무 많은 옵션으로 사용자의 혼란을 방지하고 검증된 안정성을 제공하기 위해서 밸브가 추구하는 자동화 도구 유형 및 템플릿을 제한할 필요가 있습니다.
다음을 지향하는 코드 조각이면 밸브의 프로젝트가 될 수 있습니다.

* Multi Public Cloud(AWS, Azure, GCP), Hybrid(Openstack, VMware) 쿠버네티스 인프라 구성 코드
  * 서비스 운영이 가능한 Kubernetes 인프라 생성 및 운영을 위한 코드
  * 멀티 쿠버네티스 클러스터, 하이브리드 쿠버네티스 클러스터 관리 도구 설치 및 운영을 위한 코드
* DevOps 툴체인 설치 및 연동을 위한 코드
  * 쿠버네티스 클러스터에서 구동되는 툴의 설치 및 연동을 위한 코드
  * 클라우드 서비스 형태로 제공되는 툴의 설치 및 연동을 위한 코드
* 애플리케이션 인프라를 정의한 코드 템플릿
* 애플리케이션 빌드 및 배포를 위한 코드 템플릿
  * 배포 대상 가상화 수준별(VM, 컨테이너, Serverless)별 템플릿
  * 배포 대상 서비스별(EKS, AKS, GKE, ...) 템플릿
  * 애플리케이션 빌드 도구별 템플릿
* GitOps, SRE, MSA

## Valve 프로젝트 사용자
밸브의 사용자는 DevOps 팀 또는 DevOps 팀이 제공한 밸브 기반 플랫폼에서 애플리케이션을 개발하는 개발자가 될 수 있습니다.
DevOps팀과 개발팀은 다음과 같은 기술에 대한 배경지식을 갖고 있어야 합니다.

* DevOps 팀
  * 쿠버네티스
    * 쿠버네티스 클러스터와 이를 기반으로 동작하는 서비스를 운영할 수 있어야 합니다.
  * 테라폼
    * 코드 기반으로 인프라를 정의하고 운영하기 위해서는 테라폼에 대한 이해가 필요합니다.
  * 클라우드 서비스
    * 클라우드 서비스에서 구성된 리소스에 대한 이해가 필요합니다.
  * DevOps 툴 체인
    * DevOps 툴 체인 구성하고 운영할 수 있어야 합니다.
* 애플리케이션 개발자
  * CI/CD 파이프라인 코드
    * 템플릿으로 제공되는 Jenkinsfile의 동작을 이해하고 원하는 CI/CD 파이프라인을 만들기 위해 코드를 수정할 수 있어야 합니다.
    * ...
  * 이미지 생성 코드
    * 템플릿으로 제공되는 Dockerfile의 동작을 이해하고 원하는 도커이미지를 생성하기 위해 코드를 수정할 수 있어야 합니다.
    * ...
  * 배포 형상 정의 코드
    * 템플릿으로 제공되는 배포 구성을 이해하고 원하는 배포 형상을 정의하기 위해 코드를 수정할 수 있어야 합니다.
    * ...

## Valve 하위 프로젝트
현재 valve는 다음과 같은 프로젝트로 구성되어 있습니다.

* 쿠버네티스 클러스터 생성을 위한 프로젝트
  * [valve-kops](https://github.com/opsnow-tools/valve-kops)
    * valve-kops는 kops를 기반으로 만들어진 CUI 도구입니다. valve-kops는 문답 방식으로 쿠버네티스 클러스터를 생성하고 관리할 수 있는 기능을 제공합니다.
    * EC2 기반에서 쿠버네티스를 운영하거나 마스터 노드를 직정 운영하고 싶은 경우 valve-kops를 사용할 수 있습니다.
  * [valve-eks](https://github.com/opsnow-tools/valve-eks)
    * valve-eks는 테라폼 코드를 사용하여 개발되었고 EKS 기반 쿠버네티스 클러스터를 생성하는 도구입니다.
    * EKS 외에도 쿠버네티스 클러스터를 운영하기 위해 필요한 필수 리소스를 일괄 생성합니다. (VPC, Subnet, Route53, ALB, Security Group, EFS, ...)
* DevOps 툴 체인 구성을 위한 프로젝트
  * [valve-tools](https://github.com/opsnow-tools/valve-tools)
    * valve-tools는 DevOps 툴 체인을 구성하기 위한 CUI 도구 입니다.
    * valve-tools를 문답 방식으로 적용할 DevOps 툴을 선택하여 요구되는 DevOps 툴 체인을 빠르게 구성할 수 있게 합니다.
* CI/CD 파이프라인 생성을 위한 프로젝트
  * [valve-butler](https://github.com/opsnow-tools/valve-butler)
    * valve-butler는 Jenkinsfile 작성을 위한 단위 작업을 모듈로 제공하는 프로젝트입니다.
    * 사용자가 원하는 파이프라인을 정의하기 위해서는 valve-butler 코드를 수정해야 할 수 있습니다.
  * [valve-builder](https://github.com/opsnow-tools/valve-builder)
    * valve-builder는 Jenkins 슬레이브가 실행하는 컨테이너 이미지 입니다. 빌드, 배포시 사용하는 명령어가 미리 설치되어 있습니다. 추가로 필요한 도구가 있다면 valve-builder를 수정해야 할 수 있습니다.
* 개발자 도구
  * [valve-ctl](https://github.com/opsnow-tools/valve-ctl)
    * valve-ctl은 개발자를 위한 도구 입니다. 개발자는 valve 명령을 사용해서 개발 레파지토리에 프로젝트 유형에 맞는 템플릿(Jenkinsfile, Dockerfile, Helm chart, ..)을 다운 받고 약간의 설정값 수정으로 운영 환경까지 배포가능하게 만들 수 있습니다. valve-ctl은 확장 가능하도록 설계되었고 사용자가 정의한 템플릿을 사용하게 할 수 있으며 사용자가 정의한 커맨드를 밸브 명령에 추가할 수 있는 방법을 제공합니다.

## Valve 프로젝트 시작하기 

* [밸브를 통한 애플리케이션 배포 빠르게 시작하기](./hands-on/valve-ctl-30min-quickstart.md)
* [1시간 밸브 패스트트랙](./hands-on/valve-fast-track.md)

## Valve 로드맵

### 2019
* valve-eks v1.0
  * 테라폼 템플릿 제공
  * 테라폼 모듈 제공
  * AlertNow 연동 템플릿 개발
  * 클러스터 이관 방법을 제공하는 모듈 개발
* valve-ctl v2.0
  * 사용자 정의 템플릿 개발 및 사용 방법 제공
  * 사용자 커맨드 개발 방법 제공
  * CUI에서 CLI로 리펙토링
  * R batch 템플릿 개발
  * 테라폼 템플릿 개발
  * Pandoc 템플릿 개발 (비공개)
* valve-butler v1.x
  * 테라폼으로 작성된 인프라 정의 코드의 배포 파이프라인 제공
* valve-tools v1.x
  * 독립 프로젝트로 리펙토링
  * Harbor 도입
  * Jaeger 도입
  * ArgoCD 도입
  * AlertManager 기본 설정 개발
  * Grafana 대시 보드 설정 개발
  * AWS Elasticsearch 로그 백업, 삭제 기능 개발
* valve-kops v1.x
  * 독립 프로젝트로 리펙토링
* valve-argotools (incubating)
  * GitOps 방식의 DevOps 툴 체인 생성 및 운영 템플릿 제공

### 2020
* valve-aks v1.0
  * 신규
* valve-gke v1.0
  * 신규
* valve-argotools v1.0 / valve-tools v2.0
  * valve-argotools 안정 버전 공개
  * Rancher 도입 (멀티 클러스터 관리, 카탈로그 서비스 지원)
  * ArgoRollout 도입 (Blue/Green, Canary 배포 전략 지원)
  * LDAP, OAuth 2.0 인증 적용
  * 핵심 툴 체인을 Operator로 전환
* valve-butler v2.0
  * 다양한 CI/CD 파이프라인을 수용하도록 디렉토리, 버전 관리 체계 정비
  * ArgoRollout 연동을 통한 다양한 배포 전략 지원
  * Workflow 도구와 연동
  * 보안 취약점 분석 도구 연동
* valve-opsconf (ideation)
  * 운영 설정을 GitOps 형태로 관리할 수 있는 방안 마련

## 개발 


## 라이선스 정보

TBD