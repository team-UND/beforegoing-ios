# Beforegoing-iOS

## 프로젝트 개요

'나가기전에'는 사용자가 외출 전 필요한 것을 확인할 수 있도록 돕는 iOS 애플리케이션입니다. 날씨, 미세먼지 정보와 함께 사용자가 설정한 시나리오에 따라 맞춤형 알림을 제공하여 준비물이나 해야 할 일을 잊지 않도록 도와줍니다.

## 담당 역할: CI/CD 및 개발 자동화 구축

이 프로젝트에서 저는 개발 프로세스의 안정성과 효율성을 높이기 위해 CI/CD 파이프라인을 구축하고 유지보수하는 역할을 담당했습니다. GitHub Actions와 Fastlane을 중심으로 전체 빌드, 테스트, 배포 과정을 자동화했으며, SonarCloud를 연동하여 코드 품질을 지속적으로 관리했습니다.

## CI/CD 파이프라인

### 주요 기술 스택

-   **CI/CD Orchestration**: `GitHub Actions`
-   **Build & Deploy Automation**: `Fastlane`
-   **Code Signing**: `Fastlane Match`
-   **Code Quality**: `SonarCloud`
-   **Environment Setting:**: `Bash`
-   **Communication**: `Discord Webhooks`

### 1. Pull Request 검증 워크플로우 (`validate-pr.yml`)

`main` 또는 `dev` 브랜치로 Pull Request가 생성될 때마다 실행되어 코드의 무결성을 보장합니다.

-   **트리거**: `pull_request`
-   **주요 작업**:
    1.  **Unit Tests 실행**: `Fastlane`의 `test` lane을 실행하여 모든 단위 테스트를 수행합니다. (`scan` action 사용)
    2.  **Code Coverage 리포트 생성 및 변환**: 테스트 실행 후 생성된 코드 커버리지 리포트를 `scripts/convert_coverage.py` 스크립트를 통해 SonarCloud가 분석할 수 있는 XML 형식으로 변환합니다.
    3.  **정적 코드 분석**: `SonarCloud`로 분석 결과를 전송하여 코드 스멜, 버그, 보안 취약점 등을 검사하고 PR에 코멘트를 남깁니다.
    4.  **결과 알림**: 워크플로우 실행 결과를 Discord 채널로 전송하여 팀원들이 빠르게 확인할 수 있도록 합니다.

### 2. 개발 버전 배포 워크플로우 (`deploy-to-dev.yml`)

`dev` 브랜치에 새로운 코드가 Push 되면 자동으로 TestFlight에 개발 버전을 배포합니다.

-   **트리거**: `push` (to `dev` branch)
-   **주요 작업**:
    1.  **Test & Build**: `Fastlane`의 `beta` lane을 실행합니다.
        -   `test` lane을 먼저 실행하여 배포 전 코드의 안정성을 다시 한번 확인합니다.
        -   `Fastlane Match`를 통해 코드 서명 인증서를 Git 저장소에서 가져옵니다.
        -   앱을 빌드하고 TestFlight에 업로드합니다. (`build_app`, `upload_to_testflight` actions 사용)
    2.  **결과 알림**: 배포 성공 또는 실패 결과를 Discord 채널로 전송합니다.

## Fastlane 상세 설정

`fastlane` 디렉터리 내 파일들은 CI/CD의 핵심 로직을 담고 있습니다.

-   **`Fastfile`**:
    -   `test` lane: `scan`을 사용하여 테스트를 실행하고, 커버리지 리포트를 생성하는 역할을 합니다.
    -   `beta` lane: `test` lane 실행, `match`를 통한 인증서 관리, 앱 빌드 및 TestFlight 배포까지의 과정을 정의합니다.
-   **`Appfile`**: 앱의 번들 ID, Apple ID 등 기본 정보를 중앙에서 관리하여 lane 스크립트의 재사용성과 유지보수성을 높입니다.
-   **`Matchfile`**: 코드 서명에 필요한 인증서와 프로비저닝 프로파일을 저장하는 Git 저장소의 주소를 지정합니다. 이를 통해 팀원 간의 서명 환경을 통일하고 자동화합니다.

## 커스텀 스크립트

-   **`scripts/convert_coverage.py`**: Xcode에서 생성되는 `.xcresult` 번들 내의 코드 커버리지 데이터를 SonarCloud가 이해할 수 있는 형식으로 파싱하고 변환하는 Python 스크립트입니다. CI 파이프라인에서 코드 품질 분석을 자동화하는 데 핵심적인 역할을 합니다.

## 프로젝트 커뮤니케이션 자동화

CI/CD 파이프라인 외에도 GitHub에서 발생하는 주요 이벤트를 Discord로 알리는 자동화 워크플로우를 구축하여 팀의 소통 효율을 높였습니다.

-   **`notify-assigned-issue.yml`**: 이슈가 특정 담당자에게 할당될 때 알림을 보냅니다.
-   **`notify-on-comment.yml`**: 이슈나 Pull Request에 새로운 댓글이 달릴 때 알림을 보냅니다.
