# SwiftUI + TCA를 활용한 영화 조회 앱
- 스터디(TCA), 개발기간: 2024.07.24 ~  2024.08.23
- 공공 API 사용

<div align=left>
<img src="https://github.com/user-attachments/assets/0c3690ae-6619-4963-9176-5c8bc5b6c4f9" height="350" />
<img src="https://github.com/user-attachments/assets/a305aba0-144f-4c3b-a56b-ddd22a90f5a5" height="350" />
<img src="https://github.com/user-attachments/assets/856349da-e1d3-4539-b871-f1d6a5038230" height="350" />
<br>
<img src="https://github.com/user-attachments/assets/0db11658-0d93-4b6f-a176-bdf02fda1a03" height="350" />
<img src="https://github.com/user-attachments/assets/ee9a8054-9b04-400b-b5f3-a7d36f0a9176" height="350" />
<img src="https://github.com/user-attachments/assets/5c97a293-2bd2-435d-be6d-a2f8bf797425" height="350" />

</div>
<br>

## 📋 주요기능
### 메인화면
- 전일, 금주 박스 오피스를 볼 수 있고, 영화를 선택하면 영화 상세화면으로 이동할 수 있습니다.
- 검색화면으로 바로갈 수 있는 버튼을 제공합니다.

### 검색화면
- 영화 제목, 감독 이름에 맞춰서 검색할 수 있는 기능을 제공합니다.
- 영화를 선택하면 영화 상세화면으로 이동할 수 있습니다.

### 영화 상세화면
- 영화의 장르, 러닝타임, 상영일 등 영화 기본정보를 표시하며 제작사와 등장인물 정보를 표시합니다.
- 등장인물을 선택하면, 등장인물의 정보와 활동이력을 볼 수 있는 화면으로 이동할 수 있습니다.
- 하단에는 영화에 대한 메모를 입력할 수 있으며, 메모는 하단 탭바에서 바로 모아볼 수 있습니다.

### 배우 상세화면
- 배우의 성별, 이름(영문) 등 배우의 기본정보를 표시하며, 하단에는 활동이력을 표시합니다.
- 활동이력을 선택하면, 해당 영화의 상세화면으로 이동할 수 있습니다.

<br>

## 🛠 영화 조회 앱에 사용된 라이브러리, 프레임워크
- SwiftUI, UIKit(SwiftUI에서 지원하지 않는 부분을 컨트롤 하기 위함)
- TCA
- Kingfisher

<br>

## 💡 제작 포인트
### 디자인
- Apple의 HIG를 준수하며 디자인 및 개발하였습니다.
- Apple의 기본 앱과 유사한 컬러와 디자인을 사용하여 사용자에게 거부감이 없게 설계하였습니다.
- 다양한 애니메이션을 활용하여, 팝업을 표출하거나 스크롤 시 자연스럽게 동작하도록 개발하였습니다.

### 개발
- TCA의 중요 포인트인 단방향 데이터 흐름을 지키면서 개발하였습니다.
- Dependency에 preview를 위한 dummy 데이터를 넣어 SwiftUI Preview에서도 View가 정상적으로 보일 수 있게 개발하였습니다.
- async, await를 사용한 네트워크 통신 및 사용자 데이터 흐름을 조절하여 개발하였습니다.
- 현 SwfitUI가 제공하지 않는 ScrollView Offset 등 제공하지 않는 기능을 제작하여 개발하였습니다.

<br>

## 🧐 프로젝트 후기
- TCA의 작동 원리를 이해하고, TCA를 활용하여 개발하는 방법을 학습했습니다.
- 다양한 Property Wrappers와 Macro의 존재를 학습하고, 활용했습니다.
- Task, async, await 등을 사용한 비동기 처리 방법을 학습하고, 활용했습니다.
- SwiftUI의 View가 그려지는 방법을 학습했으며, 어떤 방향을 가지고 View를 그려야 할 지 생각하게 되었습니다.
- SwiftUI의 View에 관한 다양한 modifier를 학습하고, 활용했습니다.
