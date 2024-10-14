# BerryQuest: 나무 열매 원정대

- 포켓몬 친구들을 치료하기 위해 현재 나의 위치에서 최단 거리를 탐색해서 나무 열매를 전달하자!

## 개발 환경

- 개발 언어: Swift
- 개발 환경: SwiftUI, Combine, MVVM
    - 최소: 16.6
    - 기종 호환
- 라이브러리: KakaoMapSDK ios_v2

## 주요 기능

- `메인 화면`
    - 사용자의 현재 위치와 포켓몬들의 위치를 한 눈에 파악할 수 있다.
    - 다친 포켓몬 친구들 모두에게 가기 위한 최단 경로를 확인할 수 있다.
    - 사용자의 현재 위치는 실시간 업데이트되어서 지도에 반영된다.
- `치료할 포켓몬 화면`
    - 바텀 시트에서 list목록으로 확인할 수 있다.
    - 메인 화면에서 경로 탐색을 하면 가장 방문할 순서대로 포켓몬들이 정렬된다.
    - 포켓몬을 선택하면 상세 정보를 확인할 수 있다.
- `상세 정보`
    - 포켓몬들의 이미지, 이름, 위치, 병명, 열매 정보를 확인할 수 있다.

### 화면
|내 위치와 포켓몬 위치 마커|줌 확대시 포케몬 마커|최단 경로 탐색 폴리라인|
|------|---|---|
|![image](https://github.com/user-attachments/assets/0031c57a-deda-43b1-9016-edfefebf050b)|![image](https://github.com/user-attachments/assets/1a790bb8-46dd-471f-990b-feb748c98519)|![image](https://github.com/user-attachments/assets/e83c57ed-2d44-48ff-8053-7628395adf10)|

|바텀 시트|상세 화면|위치 변경시|
|------|---|---|
|![image](https://github.com/user-attachments/assets/c67644be-68e8-4776-9cb0-e86595df27f5)|![image](https://github.com/user-attachments/assets/cf49c9ef-f2f8-4005-80d5-b49485842202)|![image](https://github.com/user-attachments/assets/cde79be4-f522-426b-a324-63fc49e3c985)
|



## 트러블 슈팅
![image](https://github.com/user-attachments/assets/155380b3-f7b2-4ce4-89ed-540d07b2e0c0)

- 내장 sheet의 .presentationDetents를 사용해서 바텀시트를 구현하였으나, 정작 뒷 화면의 MapView에서 버벅임 현상이 발견됨.
    - View 계층을 보았을 때 dimming view가 뒤의 MapView와의 상호작용을 방해하고 있음을 확인함.
        - `dimming view`: sheet나 다른 모달 방식으로 화면에 표시될 때, 배경에 나타나는 반투명한 뷰, 기본적으로 상호작용을 차단하는 역할을 하며, 뒤에 있는 다른 UI 요소와의 상호작용을 방해할 수 있음
        - `interactiveDismissDisabled()` 메스드를 사용해서 뒤의 MapView와 상호작용을 허용하더라도, 터치와 제스처 인식이 `dimming` 뷰에 우선적으로 처리되기 때문에 `MapView`나 다른 UI 요소의 제스처 인식기가 작동하지 않을 수 있다.
    
    → **`GeometryReader`**와 **`DragGesture`**를 이용하여 Custom Bottom Sheet를 구현하여, View의 `ZStack`에 MapView와 BottomSheetView를 배치하는 것으로 문제를 해결하였다.
    

## 폴더 계층
```swift
.
├── BerryQuest
│   ├── BerryQuestApp.swift
│   ├── DataModel
│   │   ├── DTO
│   │   │   ├── PocketmonInformationResponse.swift
│   │   │   └── PocketmonResponse.swift
│   │   └── DomainModel
│   │       ├── PocketmonDomain.swift
│   │       └── PokemonInformationDomain.swift
│   ├── Extension
│   │   ├── CLLocationCoordinate2D+Extension.swift
│   │   └── UIImage+Extension.swift
│   ├── Info.plist
│   ├── Network
│   │   ├── Enum
│   │   │   ├── HTTPMethod.swift
│   │   │   └── NetworkError.swift
│   │   ├── HTTPRequestBuilder
│   │   │   ├── HTTPRequestable.swift
│   │   │   └── PocketmonRequest.swift
│   │   └── Implement
│   │       └── NetworkManager.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── Resources
│   │   ├── pin_green.png
│   │   ├── pin_red.png
│   │   └── route.png
│   ├── SystemDesign
│   │   └── ContentSize.swift
│   ├── Utilis
│   │   ├── CustomBottomSheetView.swift
│   │   ├── LocationManager.swift
│   │   ├── NavigationLazyView.swift
│   │   └── RouteSearchManager.swift
│   └── View
│       ├── BottomSheet
│       │   ├── View
│       │   │   ├── PokemonContentView.swift
│       │   │   ├── PokemonDetailView.swift
│       │   │   └── PokemonListView.swift
│       │   └── ViewModel
│       │       └── PokemonDetailViewModel.swift
│       └── Map
│           ├── Service
│           │   ├── MapPoiManager.swift
│           │   └── MapPolylineManager.swift
│           ├── View
│           │   ├── KakaoMapView.swift
│           │   └── MapView.swift
│           └── ViewModel
│               └── MapViewModel.swift
├── BerryQuest.xcodeproj
└── Secrets.xcconfig
```
