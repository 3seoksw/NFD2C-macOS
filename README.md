# NFD2C Alpha (macOS)

> [!IMPORTANT]
> 현재 이 앱은 정식 릴리즈 버전이 아닌 **Alpha** 버전입니다.
> 개발이 진행 중이기 때문에, 안정성과 기능이 완전하지 않다는 점 양해 부탁드립니다.

`NFD2C`는 macOS 전용 메뉴바 앱으로, macOS 파일의 `자소분리` (`가나다`로 저장되어야 할 이름이 `ㄱㅏㄴㅏㄷㅏ`와 같이 저장되는 것) 문제를 해결해주는 프로그램입니다.
macOS에서는 파일을 [NFD](https://en.wikipedia.org/wiki/Unicode_equivalence#Normal_forms)(Normalization Form D) 방식으로 저장하며,
Windows는 [NFC](https://en.wikipedia.org/wiki/Unicode_equivalence#Normal_forms)(Normalization Form C) 방식으로 저장하기 때문에 발생하는 문제입니다.

https://github.com/user-attachments/assets/98fcb955-c3b2-403a-8fea-d0708f722488

## 기능

- **파일 이름 변환**: 지정한 디렉토리 내의 모든 파일 이름을 NFD에서 NFC 형식으로 변환.
- **실시간 디렉토리 모니터링**: 사용자가 지정한 디렉토리 내의 모든 파일들을 실시간으로 모니터링하여 변경사항이 생길 때마다 **파일 이름 변환**을 실행.
- **메뉴바 프로그램**: 메뉴바에서 조작 가능한 프로그램.

## 사용 방법

> [!NOTE]
> 정식 배포 단계가 아니기 때문에 프로그램이 아직 불완전하다는 점 양해 부탁드립니다.

1. [Github Release](https://github.com/3seoksw/NFD2C-macOS/releases/tag/v0.1.0-alpha)에서 `NFD2C.zip` 파일을 다운로드
2. 다운로드 받은 `NFD2C.zip` 파일을 압축해제
3. `NFD2C.app` 파일을 실행
4. `System Settings` - `Privacy & Security` 에서 `NFD2C`에게 권한 승인

## 사용 방법
> [!CAUTION]
> 최상위(`/USERNAME`) 또는 상위 디렉토리의 선택은 지양해주시기 바랍니다.
> 상위 디렉토리 선택 시, 너무 많은 파일들을 감시해야 하므로 시스템에 과부하가 발생할 수 있습니다.

1. 메뉴바에서 NFD2C 아이콘을 클릭
2. 우측 상단의 폴더 아이콘을 클릭하여 디렉토리 선택
3. 선택한 디렉토리 내의 모든 파일들의 변경사항을 감지
